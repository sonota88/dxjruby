package dxjruby.util;

@SuppressWarnings("serial")
public class DXJRubyException extends RuntimeException {

    public DXJRubyException(String message) {
        super(message);
    }

    public DXJRubyException() {
        super();
    }

    public DXJRubyException(Exception e) {
        super(e);
    }

}
