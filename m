Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46201207E36C1
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 22:08:53 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 4ECA9AC00FF
 for <linux-nvdimm@lists.01.org>;
 Wed, 23 May 2018 14:08:45 +0900 (JST)
Date: Wed, 23 May 2018 14:08:12 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Questions about vNVDIMM on qemu/KVM
Message-Id: <20180523140809.622F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: qemu-devel@nongnu.org
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

I'm investigating status of vNVDIMM on qemu/KVM,
and I have some questions about it. I'm glad if anyone answer them.

In my understanding, qemu/KVM has a feature to show NFIT for guest,
and it will be still updated about platform capability with this patch set.
https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04756.html

And libvirt also supports this feature with <memory model='nvdimm'>
https://libvirt.org/formatdomain.html#elementsMemory


However, virtio-pmem is developing now, and it is better
for archtectures to detect regions of NVDIMM without ACPI (like s390x)
In addition, It is also necessary to flush guest contents on vNVDIMM
who has a backend-file. 


Q1) Does ACPI.NFIT bus of qemu/kvm remain with virtio-pmem? 
    How do each roles become it if both NFIT and virtio-pmem will be available?
    If my understanding is correct, both NFIT and virtio-pmem is used to
    detect vNVDIMM regions, but only one seems to be necessary....

    Otherwize, is the NFIT bus just for keeping compatibility, 
    and virtio-pmem is promising way?

    
Q2) What bus is(will be?) created for virtio-pmem?
    I could confirm the bus of NFIT is created with <memory model='nvdimm'>,
    and I heard other bus will be created for virtio-pmem, but I could not
    find what bus is created concretely.
    ---
      # ndctl list -B
      {
         "provider":"ACPI.NFIT",
         "dev":"ndbus0"
      }
    ---
   
    I think it affects what operations user will be able to, and what 
    notification is necessary for vNVDIMM. 
    ACPI defines some operations like namespace controll, and notification
    for NVDIMM health status or others.
    (I suppose that other status notification might be necessary for vNVDIMM,
     but I'm not sure yet...)

If my understanding is wrong, please correct me.

Thanks,
---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
