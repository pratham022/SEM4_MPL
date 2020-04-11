#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "QMouseEvent"
#include "iostream"
#include "math.h"
using namespace std;

QImage image(500, 500, QImage::Format_RGB888);

float input[20][2];
float output[20][2];
int i, j, n;
float x_one, y_one;
float xm, ym;


class Matrix{
    float mat[1][3];
    friend class MainWindow;
public:
    Matrix()
    {
        mat[0][0] = 0;
        mat[0][1] = 0;
        mat[0][2] = 1;
    }
    Matrix multiply(float refX[][3])
    {
        Matrix temp;
        for(int i=0;i<1;i++)
        {
            for(int j=0;j<3;j++)
            {
                for(int k=0;k<3;k++)
                {
                    temp.mat[i][j] += mat[i][k] *  refX[k][j];
                }
            }
        }
        return temp;
    }
};

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->label->setPixmap(QPixmap::fromImage(image));
}

void MainWindow::dda(float x_one, float y_one, float x_two, float y_two)    // dda() to draw line
{
    float xinc, yinc, steps, dx, dy;
    dx = x_two-x_one;
    dy = y_two-y_one;
    if(abs(dx) > abs(dy))
        steps = abs(dx);
    else
        steps = abs(dy);
    xinc = dx/steps;
    yinc = dy/steps;
    for(int i=0;i<steps;i++)
    {
        image.setPixel(x_one, y_one, qRgb(0, 255, 0));
        x_one += xinc;
        y_one += yinc;
    }
    ui->label->setPixmap(QPixmap::fromImage(image));
}

void MainWindow::erase(float x_one, float y_one, float x_two, float y_two)
{
    float xinc, yinc, steps, dx, dy;
    dx = x_two-x_one;
    dy = y_two-y_one;
    if(abs(dx) > abs(dy))
        steps = abs(dx);
    else
        steps = abs(dy);
    xinc = dx/steps;
    yinc = dy/steps;
    for(int i=0;i<steps;i++)
    {
        image.setPixel(x_one, y_one, qRgb(0, 0, 0));
        x_one += xinc;
        y_one += yinc;
    }
    ui->label->setPixmap(QPixmap::fromImage(image));
}

void MainWindow::mousePressEvent(QMouseEvent *event)
{
    if(event->button() == Qt::LeftButton)
    {
        x_one = event->pos().x();
        y_one = event->pos().y();
        input[i][0] = x_one;
        input[i][1] = y_one;
        i++;
    }
    else if(event->button() == Qt::RightButton)
    {
        n = i;
        for(j=1;j<=i-1;j++)
        {
            dda(input[j][0], input[j][1], input[j-1][0], input[j-1][1]);
        }
        dda(input[j-1][0], input[j-1][1], input[0][0], input[0][1]);
    }
}

void MainWindow::mouseDoubleClickEvent(QMouseEvent *event)
{
    xm = event->pos().x();
    ym = event->pos().y();
    cout<<"the point given by user: "<<xm<<" "<<ym<<endl;
    image.setPixel(xm, ym, qRgb(255, 255, 255));
    ui->label->setPixmap(QPixmap::fromImage(image));
}
MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    Matrix initial, final;
    float refX[3][3];
    for(int x=0;x<3;x++)
    {
        for(int y=0;y<3;y++)
        {
            refX[x][y] = 0;
        }
    }
    refX[0][0] = refX[2][2] = 1;
    refX[1][1] = -1;

    for(int x=0;x<n;x++)
    {
        initial.mat[0][0] = input[x][0];
        initial.mat[0][1] = input[x][1];
        initial.mat[0][2] = 1;
        final.mat[0][0] = final.mat[0][1] = 0;
        final.mat[0][2] = 1;
        final = initial.multiply(refX);

        output[x][0] = final.mat[0][0];
        output[x][1] = final.mat[0][1]+500;

        cout<<input[x][0]<<" "<<input[x][1]<<endl;
        cout<<output[x][0]<<" "<<output[x][1]<<endl;
    }
    drawPolygon();
}

void MainWindow::drawPolygon()
{
    for(j=1;j<=i-1;j++)
    {
        dda(output[j][0], output[j][1], output[j-1][0], output[j-1][1]);
    }
    dda(output[j-1][0],output[j-1][1], output[0][0], output[0][1]);
}

void MainWindow::on_pushButton_2_clicked()
{
    Matrix initial, final;
    float refY[3][3];
    for(int x=0;x<3;x++)
    {
        for(int y=0;y<3;y++)
        {
            refY[x][y] = 0;
        }
    }
    refY[0][0] = -1;
    refY[2][2] = 1;
    refY[1][1] = 1;

    for(int x=0;x<n;x++)
    {
        initial.mat[0][0] = input[x][0];
        initial.mat[0][1] = input[x][1];
        initial.mat[0][2] = 1;
        final.mat[0][0] = final.mat[0][1] = 0;
        final.mat[0][2] = 1;
        final = initial.multiply(refY);

        output[x][0] = final.mat[0][0]+500;
        output[x][1] = final.mat[0][1];

        cout<<input[x][0]<<" "<<input[x][1]<<endl;
        cout<<output[x][0]<<" "<<output[x][1]<<endl;
    }
    drawPolygon();
}

void MainWindow::on_pushButton_3_clicked()
{
    Matrix initial, final;
    float refXY[3][3];
    for(int x=0;x<3;x++)
    {
        for(int y=0;y<3;y++)
        {
            refXY[x][y] = 0;
        }
    }
    refXY[0][1] = 1;
    refXY[1][0] = 1;
    refXY[2][2] = 1;

    for(int x=0;x<n;x++)
    {
        initial.mat[0][0] = input[x][0];
        initial.mat[0][1] = input[x][1];
        initial.mat[0][2] = 1;
        final.mat[0][0] = final.mat[0][1] = 0;
        final.mat[0][2] = 1;
        final = initial.multiply(refXY);

        output[x][0] = final.mat[0][0];
        output[x][1] = final.mat[0][1];

        cout<<input[x][0]<<" "<<input[x][1]<<endl;
        cout<<output[x][0]<<" "<<output[x][1]<<endl;
    }
    drawPolygon();
}

void MainWindow::on_pushButton_4_clicked()
{
    double angle = ui->textEdit->toPlainText().toDouble();
    angle = angle*3.14/180;                 // angle converted to radians
    rotation(angle);
    drawPolygon();
}

void MainWindow::rotation(double angle)
{
    Matrix initial;                 // [x, y, 1] matrix
    Matrix final;                   // [x', y', 1] matrix
    float rotationMat[3][3];       // 3x3 rotation matrix
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<3;j++)
        {
            rotationMat[i][j] = 0;
        }
    }
    rotationMat[0][0] = rotationMat[1][1] = cos(angle);
    rotationMat[0][1] = -1*sin(angle);
    rotationMat[1][0] = sin(angle);
    rotationMat[2][0] = (-1*xm*cos(angle)) + ym*sin(angle) + xm;
    rotationMat[2][1] = (-1*xm*sin(angle)) - ym*cos(angle) + ym;
    rotationMat[2][2] = 1;
    // rotation matrix initialised

    for(i=0;i<n;i++)
    {
        initial.mat[0][0] = input[i][0];
        initial.mat[0][1] = input[i][1];
        initial.mat[0][2] = 1;              // initialising initial matrix [x y 1]

        final = initial.multiply(rotationMat);

        output[i][0] = final.mat[0][0]-250;
        output[i][1] = final.mat[0][1];
        cout<<output[i][0]<<" "<<output[i][1]<<endl;
    }
}
