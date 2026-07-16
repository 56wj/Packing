package cn.edu.hdu.packing_service.stream;


import cn.edu.hdu.packing_service.pojo.Result;
import cn.edu.hdu.packing_service.stream.encoder.ResultEncoder;
import cn.edu.hdu.packing_service.utils.DateUtil;
import cn.edu.hdu.packing_service.utils.JwtUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint(value = "/suspendpackingWebsocket" , encoders = {ResultEncoder.class})
@Component
public class SuspendPackingWebsocket {

    //记录连接的客户端
    public static Map<String, Session> clients = new ConcurrentHashMap<>();

    /**
     * userId关联sid（解决同一用户id，在多个web端连接的问题）
     */
    public static Map<String, Set<String>> conns = new ConcurrentHashMap<>();

    private String sid = null;

    private String userId;

    /**
     * 连接成功后调用的方法
     * @param session

     */
    @OnOpen
    public void onOpen(Session session) {
        Map<String , String> param = parseQueryParams(String.valueOf(session.getRequestURI()));
        String token = param.get("token");
        Map<String , Object> claims = JwtUtil.parseToken(token);
        Integer currentUser = (Integer) claims.get("id");
        this.sid = UUID.randomUUID().toString();
        this.userId = String.valueOf(currentUser);
        System.out.println(DateUtil.getNowTime() +  userId + "连接成功");

        clients.put(this.sid, session);

        Set<String> clientSet = conns.get(userId);
        if (clientSet==null){
            clientSet = new HashSet<>();
            conns.put(userId,clientSet);
        }
        clientSet.add(this.sid);
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose() {
        clients.remove(this.sid);
    }

    /**
     * 判断是否连接的方法
     * @return
     */
    public static boolean isServerClose() {
        if (PalletPackingWebsocket.clients.values().size() == 0) {
            System.out.println("已断开");
            return true;
        }else {
            System.out.println("已连接");
            return false;
        }
    }


    /**
     * 接收消息
     * @param message
     */
    public static void sendMessage(String message){

        System.out.println(DateUtil.getNowTime() + "信息发送给所有用户");
        for (Session session1 : PalletPackingWebsocket.clients.values()) {
            try {
                session1.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 根据用户id发送给某一个用户
     **/
    public static void sendMessageByUserId(String userId , Result message) {

        System.out.println(DateUtil.getNowTime() + "信息发送给用户" + userId);
        System.out.println(DateUtil.getNowTime() + "发送短信长度" + message.toString());

        if (!StringUtils.isEmpty(userId)) {
            Set<String> clientSet = conns.get(userId);
            if (clientSet != null) {
                Iterator<String> iterator = clientSet.iterator();
                while (iterator.hasNext()) {
                    String sid = iterator.next();
                    Session session = clients.get(sid);
                    if (session != null) {
                        try {
                            session.getBasicRemote().sendObject((Object) message);
                        } catch (IOException e) {
                            e.printStackTrace();
                        } catch (EncodeException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
    }

    /**
     * 收到客户端消息后调用的方法
     * @param message
     * @param session
     */
    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println(DateUtil.getNowTime() + "悬空托盘收到来自窗口"+this.userId+"的信息:"+message);
    }

    /**
     * 发生错误时的回调函数
     * @param error
     */
    @OnError
    public void onError(Throwable error) {
        error.printStackTrace();
    }

    public static Map<String, String> parseQueryParams(String wsUrl) {
        Map<String, String> queryParams = new HashMap<>();

        try {
            // 将WebSocket URL替换为HTTP URL，仅用于解析查询参数
            String httpUrl = wsUrl.replaceFirst("^ws", "http");
            URL url = new URL(httpUrl);
            String query = url.getQuery();
            if (query != null && !query.isEmpty()) {
                // 分割查询字符串为单独的"name=value"对
                String[] pairs = query.split("&");
                for (String pair : pairs) {
                    int idx = pair.indexOf("=");
                    // 对于每个参数，将名称和值解码并存储到Map中
                    String key = URLDecoder.decode(pair.substring(0, idx), "UTF-8");
                    String value = URLDecoder.decode(pair.substring(idx + 1), "UTF-8");
                    queryParams.put(key, value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return queryParams;
    }
}
