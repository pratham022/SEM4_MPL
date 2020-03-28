#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "QMouseEvent"
#include "iostream"
using namespace std;

QImage image(500, 500, QImage::Format_RGB888);

int i=0, j=0;
int x1, y1;
int r, g, b;
int n;

class Point
{
    int x_col, y_col;
    friend class MainWindow;
};
Point arr[20];



MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->label->setPixmap(QPixmap::fromImage(image));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::dda(float x1, float y1, float x2, float y2)
{
    float xinc, yinc, steps, dx, dy;
    dx = x2-x1;
    dy = y2-y1;
    if(abs(dx) > abs(dy))
        steps = abs(dx);
    else
        steps = abs(dy);
    xinc = dx/steps;
    yinc = dy/steps;
    for(int i=0;i<steps;i++)
    {
        image.setPixel(x1, y1, qRgb(0, 255, 0));
        x1 += xinc;
        y1 += yinc;
    }
    ui->label->setPixmap(QPixmap::fromImage(image));
}


void MainWindow::mousePressEvent(QMouseEvent *event)        // polygon vertices are drawn using left click..after we click right, this process stops and polygon
                                                            // is drawn (excluding the right clicked vertex!)
{
    int x, y;
        if(event->button() == Qt::RightButton)
        {
            n=i;
            drawPolygon();
        }
        else
        {
            x=event->pos().x();
            y=event->pos().y();
            image.setPixel(x, y, qRgb(255,255,0));
            ui->label->setPixmap(QPixmap::fromImage(image));
            arr[i].x_col=x;
            arr[i].y_col=y;
            i++;
        }
}
void MainWindow::drawPolygon()
{
    i=0;
    j=1;
    for(int k=0;k<n;k++)
    {
        dda(arr[i].x_col, arr[i].y_col, arr[j].x_col, arr[j].y_col);
        i=(i+1)%n;
        j=(j+1)%n;
    }
}

void MainWindow::mouseDoubleClickEvent(QMouseEvent *event)
{
    float x, y;
    if(event->button() == Qt::LeftButton)
    {
        cout<<"double clicked!"<<endl;
        x = event->pos().x();
        y = event->pos().y();
        boundary(x, y, qRgb(r, g, b), qRgb(0, 255, 0));
        ui->label->setPixmap(QPixmap::fromImage(image));
    }
}
void MainWindow::boundary(int x, int y, QRgb fillcol, QRgb boundcol)
{
       QRgb tempcol = image.pixel(x, y);
       if(tempcol != boundcol && tempcol!= fillcol)
       {
           image.setPixel(x, y, fillcol);
           boundary(x+1, y, fillcol, boundcol);
           boundary(x, y+1, fillcol, boundcol);
           if(x-1>0)
               boundary(x-1, y, fillcol, boundcol);
           if(y-1>0)
               boundary(x, y-1, fillcol, boundcol);
       }
}

void MainWindow::on_horizontalSlider_valueChanged(int value)
{
        r = value;
}

void MainWindow::on_horizontalSlider_2_valueChanged(int value)
{
        g = value;
}

void MainWindow::on_horizontalSlider_3_valueChanged(int value)
{
        b = value;
}


























