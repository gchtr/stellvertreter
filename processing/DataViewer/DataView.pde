import java.util.Arrays;

import ddf.minim.analysis.*;
import ddf.minim.*;

class DataView
{
  float[]  _curList = null;
  float    _minVal;
  float    _maxVal;
  float    _timeSteps;
  color    _color;
  FFT      _fft;

  DataView() {}

  DataView(Table table, int column, float timeSteps, color col)
  {
    set(table, column, timeSteps, col);
  }

  void set(Table table, int column, float timeSteps, color col)
  {
    _timeSteps = timeSteps;
    _color = col;

    int i = 0;
    _curList = new float[table.getRowCount()];
    for (TableRow row : table.rows())
    {
      _curList[i] = row.getFloat(column);
      i++;
    }

    init();

    println(_minVal);
    println(_maxVal);
  }

  void calcMinMax()
  {
    // checkout min/max
    _minVal = Float.MAX_VALUE;
    _maxVal = -Float.MAX_VALUE;

    for (int i=0;i < _curList.length;i++)
    {
      if (_minVal > _curList[i])
        _minVal = _curList[i];

      if (_maxVal < _curList[i])
        _maxVal = _curList[i];
    }
  }

  int nearestPower(int value)
  {
    int i = 1;

    if(value == 0)
      return -1;      /* Error! */
    while(true)
    {
      if (value == 1)
        return i;
      else if (value == 3)
        return i*4;
      value >>= 1;
      i *= 2;
    }
  }

  void init()
  {
    calcMinMax();

    //    int timeSize = 1024*2*2;
    int timeSize =  nearestPower(_curList.length);
    int sampleRate = 44100*200;

    _fft = new FFT(timeSize, sampleRate);
    _fft.forward(Arrays.copyOfRange(_curList, 0, timeSize));
  }

  void draw(color col)
  {
    if (_curList == null)
      return;

    pushStyle();
    noFill();

    stroke(col);

    // draw signal
    beginShape();
    for (int i=0; i < _curList.length;i++)
      vertex(_timeSteps * i, - _curList[i]);
    endShape();

    // draw the spectrum
    stroke(col);

    for (int i = 0; i < _fft.specSize(); i++)
    {
      line(i, height/2, i, height/2 - _fft.getBand(i)*.01);
    }

    popStyle();
  }
  
  void setLeveling(float scale, float offset)//,int alignment)
  {
    float faq = 1.0f / (_maxVal - _minVal);
    for (int i=0;i < _curList.length;i++)
    {
      _curList[i] = ((_curList[i] - _minVal) * faq) * scale + offset;
    }
    init();
  }

  float getWidth()
  {
    return _timeSteps * _curList.length;
  }

  float getHeight()
  {
    return _maxVal - _minVal;
  }
}

