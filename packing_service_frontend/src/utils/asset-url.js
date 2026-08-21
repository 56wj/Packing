const ABSOLUTE_URL_RE = /^[a-z][a-z\d+\-.]*:\/\//i

function getCurrentOrigin() {
  if (typeof window !== 'undefined' && window.location && window.location.origin) {
    return window.location.origin
  }
  return (process.env.VUE_APP_HTTP_URL || '').replace(/\/$/, '')
}

function buildCurrentOriginUrl(pathname, search = '', hash = '') {
  return `${getCurrentOrigin()}${pathname}${search}${hash}`
}

export function getAssetUrl(address) {
  if (!address) {
    return ''
  }

  const rawAddress = String(address).trim()
  if (!rawAddress) {
    return ''
  }

  if (ABSOLUTE_URL_RE.test(rawAddress)) {
    try {
      const url = new URL(rawAddress)
      if (url.pathname.startsWith('/images/')) {
        return buildCurrentOriginUrl(url.pathname, url.search, url.hash)
      }
      return rawAddress
    } catch (error) {
      return rawAddress
    }
  }

  const normalizedPath = rawAddress.replace(/^\/+/, '')
  return buildCurrentOriginUrl(`/${normalizedPath}`)
}

export function getAssetFileName(address) {
  const url = getAssetUrl(address)
  const pathname = ABSOLUTE_URL_RE.test(url) ? new URL(url).pathname : url
  return decodeURIComponent(pathname.split('/').pop() || '')
}
