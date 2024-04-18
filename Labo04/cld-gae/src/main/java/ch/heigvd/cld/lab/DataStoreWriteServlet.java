package ch.heigvd.cld.lab;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.utils.SystemProperty;
import java.io.IOException;
import java.util.Optional;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DataStoreWrite", value = "/datastorewrite")
public class DataStoreWriteServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        var kind = Optional.ofNullable(request.getParameter("_kind"))
                .orElseThrow(() -> new IllegalArgumentException("Missing required parameter _kind"));
        var id = Optional.ofNullable(request.getParameter("_id")).map(Long::parseLong)
                .orElseThrow(() -> new IllegalArgumentException("Missing required parameter _id"));

        response.setContentType("text/plain");
        var pw = response.getWriter();
        pw.println("Writing entity to datastore.");

        var datastore = DatastoreServiceFactory.getDatastoreService();
        var book = new Entity(kind, id);

        request.getParameterMap().forEach((key, value) -> {
            if (key.startsWith("_")) {
                return;
            }

            book.setProperty(key, value[0]);
        });

        datastore.put(book);
    }
}
