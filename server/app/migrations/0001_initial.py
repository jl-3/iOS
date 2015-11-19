# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Account',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('balance', models.PositiveIntegerField(default=0)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='AccountHistory',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('amount', models.PositiveIntegerField()),
                ('submit_time', models.DateTimeField()),
                ('done', models.BooleanField()),
                ('done_at', models.DateTimeField()),
                ('account', models.ForeignKey(to='app.Account')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='BankCard',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('bank_name', models.CharField(max_length=100)),
                ('card_number', models.CharField(unique=True, max_length=100)),
                ('account', models.ForeignKey(to='app.Account')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='BankCodeInfo',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('org_code', models.CharField(max_length=30)),
                ('bank_name', models.CharField(max_length=30)),
                ('card_name', models.CharField(max_length=30)),
                ('card_type', models.CharField(max_length=2)),
                ('card_number_length', models.PositiveIntegerField()),
                ('bin_code_length', models.PositiveIntegerField()),
                ('bin_code', models.CharField(max_length=30)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Certification',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=100)),
                ('img', models.ImageField(blank=True, upload_to='', null=True)),
                ('verified', models.BooleanField()),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Comment',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('ma_degree', models.PositiveIntegerField()),
                ('la_degree', models.PositiveIntegerField()),
                ('content', models.CharField(max_length=500)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Coupon',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=50)),
                ('amount', models.PositiveIntegerField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('expired_at', models.DateTimeField()),
                ('used', models.BooleanField()),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Feedback',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('contact', models.CharField(max_length=30)),
                ('content', models.CharField(max_length=500)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Grade',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(unique=True, max_length=10)),
                ('leaf', models.BooleanField()),
                ('superset', models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, default=None, null=True, to='app.Grade', blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='GradeSubject',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('grade', models.ForeignKey(to='app.Grade')),
            ],
        ),
        migrations.CreateModel(
            name='InterviewRecord',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('reviewed_at', models.DateTimeField(auto_now=True)),
                ('review_msg', models.CharField(max_length=1000)),
                ('status', models.CharField(max_length=1, choices=[('t', '待认证'), ('a', '已认证'), ('r', '已拒绝')], default='t')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Level',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(unique=True, max_length=20)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('viewed', models.BooleanField()),
                ('deleted', models.BooleanField()),
                ('title', models.CharField(max_length=100)),
                ('content', models.CharField(max_length=1000)),
                ('_type', models.CharField(max_length=1, choices=[('s', '系统消息'), ('f', '收入消息'), ('c', '课程消息'), ('a', '审核消息'), ('m', '评论消息')])),
                ('via', models.CharField(max_length=1, choices=[('s', '短信'), ('m', '邮件'), ('n', '通知栏提醒')])),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('price', models.PositiveIntegerField()),
                ('hours', models.PositiveIntegerField()),
                ('charge_id', models.CharField(max_length=100)),
                ('total', models.PositiveIntegerField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('paid_at', models.DateTimeField()),
                ('status', models.CharField(max_length=2, choices=[('u', '待付款'), ('p', '已付款'), ('d', '已取消'), ('c', '已完成')])),
                ('coupon', models.ForeignKey(to='app.Coupon')),
                ('grade_subject', models.ForeignKey(to='app.GradeSubject')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Parent',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('student_name', models.CharField(max_length=50)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Person',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=200, default='')),
                ('gender', models.CharField(max_length=1, choices=[('f', '女'), ('m', '男'), ('u', '未知')], default='u')),
                ('avatar', models.ImageField(blank=True, upload_to='', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Region',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=50)),
                ('admin_level', models.PositiveIntegerField()),
                ('leaf', models.BooleanField()),
                ('superset', models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, default=None, null=True, to='app.Region', blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='RegionGradeSubjectLevelPrice',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('price', models.PositiveIntegerField()),
                ('grade_subject', models.ForeignKey(to='app.GradeSubject')),
                ('level', models.ForeignKey(to='app.Level')),
                ('region', models.ForeignKey(to='app.Region')),
            ],
        ),
        migrations.CreateModel(
            name='RegionWeeklyTimeSlot',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('region', models.ForeignKey(to='app.Region')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Role',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(unique=True, max_length=20)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='School',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=100)),
                ('address', models.CharField(max_length=200)),
                ('thumbnail', models.ImageField(blank=True, upload_to='schools', null=True)),
                ('center', models.BooleanField()),
                ('longitude', models.IntegerField()),
                ('latitude', models.IntegerField()),
                ('region', models.ForeignKey(to='app.Region')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Subject',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(unique=True, max_length=10)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Teacher',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=200)),
                ('degree', models.CharField(max_length=2, choices=[('h', '高中'), ('s', '专科'), ('b', '本科'), ('p', '研究生')])),
                ('active', models.BooleanField()),
                ('fulltime', models.BooleanField()),
                ('grade_subjects', models.ManyToManyField(to='app.GradeSubject')),
                ('level', models.ForeignKey(to='app.Level')),
                ('person', models.ForeignKey(to='app.Person')),
                ('schools', models.ManyToManyField(to='app.School')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='TeacherWeeklyTimeSlot',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('teacher', models.ForeignKey(to='app.Teacher')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='TimeSlot',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('start', models.DateTimeField()),
                ('end', models.DateTimeField()),
                ('cancled', models.BooleanField()),
                ('attended', models.BooleanField()),
                ('commented', models.BooleanField()),
                ('confirmed_by', models.CharField(max_length=1, choices=[('s', 'System'), ('h', 'Human')])),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('last_updated_at', models.DateTimeField(auto_now=True)),
                ('last_updated_by', models.ForeignKey(null=True, to='app.Person', blank=True)),
                ('order', models.ForeignKey(to='app.Order')),
                ('transformed_from', models.ForeignKey(null=True, to='app.TimeSlot', blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='WeeklyTimeSlot',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('weekday', models.PositiveIntegerField()),
                ('start', models.TimeField()),
                ('end', models.TimeField()),
            ],
        ),
        migrations.AlterUniqueTogether(
            name='weeklytimeslot',
            unique_together=set([('weekday', 'start', 'end')]),
        ),
        migrations.AddField(
            model_name='teacherweeklytimeslot',
            name='weekly_time_slots',
            field=models.ManyToManyField(to='app.WeeklyTimeSlot'),
        ),
        migrations.AddField(
            model_name='regionweeklytimeslot',
            name='weekly_time_slots',
            field=models.ManyToManyField(to='app.WeeklyTimeSlot'),
        ),
        migrations.AddField(
            model_name='person',
            name='role',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, null=True, to='app.Role', blank=True),
        ),
        migrations.AddField(
            model_name='person',
            name='user',
            field=models.OneToOneField(to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='parent',
            name='person',
            field=models.ForeignKey(null=True, to='app.Person', blank=True),
        ),
        migrations.AddField(
            model_name='order',
            name='parent',
            field=models.ForeignKey(to='app.Parent', null=True),
        ),
        migrations.AddField(
            model_name='order',
            name='school',
            field=models.ForeignKey(to='app.School'),
        ),
        migrations.AddField(
            model_name='order',
            name='teacher',
            field=models.ForeignKey(to='app.Teacher'),
        ),
        migrations.AddField(
            model_name='order',
            name='weekly_time_slots',
            field=models.ManyToManyField(to='app.WeeklyTimeSlot'),
        ),
        migrations.AddField(
            model_name='message',
            name='to',
            field=models.ForeignKey(to='app.Person'),
        ),
        migrations.AddField(
            model_name='interviewrecord',
            name='reviewed_by',
            field=models.ForeignKey(to='app.Person'),
        ),
        migrations.AddField(
            model_name='interviewrecord',
            name='teacher',
            field=models.ForeignKey(to='app.Teacher'),
        ),
        migrations.AddField(
            model_name='gradesubject',
            name='subject',
            field=models.ForeignKey(to='app.Subject'),
        ),
        migrations.AddField(
            model_name='feedback',
            name='person',
            field=models.ForeignKey(null=True, to='app.Person', blank=True),
        ),
        migrations.AddField(
            model_name='coupon',
            name='person',
            field=models.ForeignKey(to='app.Person'),
        ),
        migrations.AddField(
            model_name='comment',
            name='time_slot',
            field=models.ForeignKey(to='app.TimeSlot'),
        ),
        migrations.AddField(
            model_name='certification',
            name='person',
            field=models.ForeignKey(to='app.Person'),
        ),
        migrations.AddField(
            model_name='accounthistory',
            name='bankcard',
            field=models.ForeignKey(to='app.BankCard'),
        ),
        migrations.AddField(
            model_name='accounthistory',
            name='done_by',
            field=models.ForeignKey(related_name='processed_withdraws', null=True, to='app.Person', blank=True),
        ),
        migrations.AddField(
            model_name='account',
            name='teacher',
            field=models.OneToOneField(to='app.Teacher'),
        ),
        migrations.AlterUniqueTogether(
            name='regiongradesubjectlevelprice',
            unique_together=set([('region', 'grade_subject', 'level')]),
        ),
        migrations.AlterUniqueTogether(
            name='gradesubject',
            unique_together=set([('grade', 'subject')]),
        ),
    ]
