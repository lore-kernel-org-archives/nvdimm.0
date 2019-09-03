Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B64221A09130
 for <linux-nvdimm@lists.01.org>; Tue,  3 Sep 2019 14:21:33 -0700 (PDT)
From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: daxctl fails to reconfigure to system-ram when DAX modules built-in?
Message-ID: <7b6e4dcd-6373-24e2-65f2-d08b2de461fb@inria.fr>
Date: Tue, 3 Sep 2019 23:20:19 +0200
MIME-Version: 1.0
Content-Language: en-US
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello

It looks like daxctl fails to reconfigure to system-ram when
DAX modules are built-in the kernel:

$ daxctl reconfigure-device --mode=system-ram dax1.0 -v
libdaxctl: daxctl_insert_kmod_for_mode: dax1.0: a modalias lookup list was not created
error reconfiguring devices: No such device or address
reconfigured 0 devices

It looks like things were failing in kmod_module_new_from_lookup()

I changed my .config with this and now it works:
-CONFIG_DEV_DAX=y
-CONFIG_DEV_DAX_PMEM=y
-CONFIG_DEV_DAX_KMEM=y
+CONFIG_DEV_DAX=m
+CONFIG_DEV_DAX_PMEM=m
+CONFIG_DEV_DAX_KMEM=m

(and +CONFIG_DEV_DAX_PMEM_COMPAT=m but it's now disabled in modprobe.d)


This is with 5.2.11.

Thanks
Brice

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
