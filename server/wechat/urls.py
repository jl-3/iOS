from django.conf.urls import include, url
from django.views.generic.base import TemplateView
from . import views

urlpatterns = [
    url(r'^schools/$', views.SchoolsView.as_view(), name="schools"),
    url(r'^schools/detail/(?P<id>[0-9]+)/$', views.SchoolDetailView.as_view(), name="school-detail"),
    url(r'^schools/map/(?P<pk>[0-9]+)/$', views.SchoolMapView.as_view(), name='school-map'),
    url(r'^teachers/$', views.TeachersView.as_view(), name="teachers"),
    url(r'^teachers/detail/(?P<id>[0-9]+)/$', views.TeacherDetailView.as_view(), name="teacher-detail"),
    # url(r'^send_template_ms/$', views.send_template_msg, name="send_template_msg"),
    url(r'^order/course_choosing/$', views.CourseChoosingView.as_view(), name="order-course-choosing"),
    url(r'^order/coupon/list/$', views.CouponListView.as_view(), name="order-coupon-list"),
    url(r'^order/evaluate/list/$', views.EvaluateListView.as_view(), name="order-evaluate-list"),
    url(r'^teacher/$', views.teacher_view, name="teacher"),
    url(r'^teacher/schools/$', views.getSchoolsWithDistance, name="teacher-schools"),
    url(r'^phone_page/', views.phone_page, name="phone_page"),
    url(r'^add_openid/', views.add_openid, name="add_openid"),
    url(r'^check_phone/', views.check_phone, name="check_phone"),
    url(r'^doc/agree/$', TemplateView.as_view(template_name="wechat/doc/policy.html"), name="doc-agree"),
    url(r'^pay/notify/', views.wx_pay_notify_view, name="wx_pay_notify"),
]
