package dxjruby;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import dxjruby.DrawQueue.Command;

public class DrawQueueTest {

    @DisplayName("should be sorted in asc order")
    @Test
    void test_getSortedZList() {
        DrawQueue sut = new DrawQueue();

        sut.TEST__add(123, new Command(null));
        sut.TEST__add(1, new Command(null));
        sut.TEST__add(12, new Command(null));

        List<Integer> zs = sut.getSortedZList();

        assertEquals(1, zs.get(0));
        assertEquals(12, zs.get(1));
        assertEquals(123, zs.get(2));
    }

}
