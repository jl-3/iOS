# -*- coding: utf-8 -*-
# Generated by Django 1.9.4 on 2016-03-25 09:18
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0131_copy_policy'),
    ]

    operations = [
        migrations.DeleteModel(
            name='Policy',
        ),
        migrations.AlterModelOptions(
            name='timeslot',
            options={'ordering': ['-start', '-created_at']},
        ),
        migrations.AlterField(
            model_name='staticcontent',
            name='name',
            field=models.CharField(max_length=100, unique=True),
        ),
    ]
