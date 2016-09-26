Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0725.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::725])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEB771A1DF8
 for <linux-nvdimm@lists.01.org>; Mon, 26 Sep 2016 09:16:18 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: /dev/dax size
Date: Mon, 26 Sep 2016 16:16:17 +0000
Message-ID: <DF4PR84MB01695337C9BD0AB787BA52D4ABCD0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
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
To: "'dan.j.williams@intel.com'" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

How is an application supposed to detect the max mmap() size possible
for a /dev/daxNN device?

fio, for example, doesn't know what size to use.  Its os/os-linux.h
does not define FIO_HAVE_CHARDEV_SIZE and it has no chardev_size
function to determine the size of a character device.


---
Robert Elliott, HPE Persistent Memory




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
