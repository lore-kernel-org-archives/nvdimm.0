Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F83C20958BC2
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:39:33 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B1823AC02AD
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:42:10 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local
 (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
 by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 0533A32884B
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:42:10 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: [RFC patch 0/4]ndctl: nvdimmd: notify/monitor the feathers of over
 threshold event
Date: Fri, 1 Sep 2017 01:42:09 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222756C8BF@g01jpexmbkw01>
Content-Language: ja-JP
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello,



This is my first time to experience OSS world. I hope I can contribute to NVDIMM development.



This is a patch set of nvdimmd, a tiny daemon to monitor the features of over

threshold events. It finds and monitors all of the dimms which support smart

threshold. Although at this time, nvdimm daemon only outputs NVDIMM's status to

systemlog, I would like to get comments/opinions.



The output includes dimm's name, health state and spares percentage, etc.

Here is a sample of the output.



            nvdimm warning: dimm over threshold notify [nmem2]

            health_state: non-critical

            spares_percentage: 75



About compiling the nvdimmd, I am not sure whether ndctl using automake can be

merged with into kernel or not[1], so a simple makefile is included. If it is

necessary to write into automake, please kindly let me know.



Here is TODO list:

 - Currently, if multiply events are notified in the same time, nvdimmd may lose some of them.

   I suppose it depends on select()’s specification, and I tried to use poll() instead of select(),

but it did not work well. So I need more research on select() and poll().

- Change the makefile to automake if necessary.

- Add more information of dimm into the notification.

- Add a config file to configure the parameters and initial settings for nvdimmd.

- Implement a feature(framework) so that nvdimmd can call external applications.



[1] https://lkml.org/lkml/2017/7/26/245



--

QI Fuli <qi.fuli@jp.fujitsu.com<mailto:qi.fuli@jp.fujitsu.com>>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
