package com.jjoe64.graphview_demos.examples;

import android.os.Handler;

import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;
import com.jjoe64.graphview_demos.FullscreenActivity;
import com.jjoe64.graphview_demos.R;

import java.util.Random;

/**
 * Created by jonas on 10.09.16.
 */
public class FixedFrame extends BaseExample {
    private final Handler mHandler = new Handler();
    private Runnable mTimer;
    private double graphLastXValue = 0d;
    private LineGraphSeries<DataPoint> mSeries;
    private LineGraphSeries<DataPoint> mSeries2;
    private LineGraphSeries<DataPoint> mSeries3;

    @Override
    public void onCreate(FullscreenActivity activity) {
        GraphView graph = (GraphView) activity.findViewById(R.id.graph);
        initGraph(graph);
    }

    @Override
    public void initGraph(GraphView graph) {
        graph.getViewport().setXAxisBoundsManual(false);

        graph.getViewport().setYAxisBoundsManual(false);

        // first mSeries is a line
        mSeries = new LineGraphSeries<>();
        graph.addSeries(mSeries);

        mSeries2 = new LineGraphSeries<>();
        graph.addSeries(mSeries2);

        mSeries3 = new LineGraphSeries<>();
        graph.addSeries(mSeries3);
    }

    public void onResume() {
        mTimer = new Runnable() {
            @Override
            public void run() {
                graphLastXValue += 1d;
                mSeries.appendData(new DataPoint(graphLastXValue, getRandom()), false, 20000);
                mSeries2.appendData(new DataPoint(graphLastXValue, getRandom()), false, 20000);
                mSeries3.appendData(new DataPoint(graphLastXValue, getRandom()), false, 20000);
                mHandler.postDelayed(this, 10);
            }
        };
        mHandler.postDelayed(mTimer, 10);
    }

    public void onPause() {
        mHandler.removeCallbacks(mTimer);
    }

    private double getRandom() {
        return Math.random() * 40;
    }
}
