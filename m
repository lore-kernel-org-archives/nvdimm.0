Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8828A1A1E02
 for <linux-nvdimm@lists.01.org>; Mon, 26 Sep 2016 12:57:39 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id t83so220436346oie.3
 for <linux-nvdimm@lists.01.org>; Mon, 26 Sep 2016 12:57:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB01695337C9BD0AB787BA52D4ABCD0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <DF4PR84MB01695337C9BD0AB787BA52D4ABCD0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Sep 2016 12:57:38 -0700
Message-ID: <CAPcyv4ixgpxp+diam0y3RkCTMroTbETcQ0Vh17JvCwgUA02Keg@mail.gmail.com>
Subject: Re: /dev/dax size
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 26, 2016 at 9:16 AM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
> How is an application supposed to detect the max mmap() size possible
> for a /dev/daxNN device?

The 'size' sysfs attribute.

> fio, for example, doesn't know what size to use.  Its os/os-linux.h
> does not define FIO_HAVE_CHARDEV_SIZE and it has no chardev_size
> function to determine the size of a character device.

Hmm, seems fio would do the right thing if /dev/dax responded to block
device size ioctl.  But I think I'd rather teach fio about device-dax
explicitly since the i/o engine need not worry about page-cache
management.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
