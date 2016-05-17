Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lb0-x22a.google.com (mail-lb0-x22a.google.com
 [IPv6:2a00:1450:4010:c04::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6135B1A1EE1
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 08:36:34 -0700 (PDT)
Received: by mail-lb0-x22a.google.com with SMTP id ww9so7416211lbc.2
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 08:36:29 -0700 (PDT)
MIME-Version: 1.0
From: Yigal Korman <yigal@plexistor.com>
Date: Tue, 17 May 2016 18:36:08 +0300
Message-ID: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
Subject: Legacy NVDIMM-F over EFI
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
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, elliott@hpe.com, Toshi Kani <toshi.kani@hp.com>, jmoyer@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Hi all,
I've got a couple of legacy 'type 12' NVDIMM-F modules in our lab I've
been successfully testing.
Recently I moved them to a new system where EFI bootloader is used
(CentOS 7 installed with EFI) and  was surprised to see that they're
not identified as legacy 'type 12' persistent memory, are not caught
by the 'nd_pmem' driver and I don't get /dev/pmemX devices.
They show as 'type 7' in the E820 map and 'Persistent memory' in /proc/iomem.
Is this the intended behavior? shouldn't they be identified as legacy
if they don't have NFIT?

Thanks,
Yigal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
