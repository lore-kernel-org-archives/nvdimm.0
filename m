Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 349C22095A323
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 10:04:28 -0700 (PDT)
Received: by mail-ot0-x230.google.com with SMTP id r67so34338031ota.1
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 10:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49r2yjc1go.fsf@segfault.boston.devel.redhat.com>
References: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
 <x49r2yjc1go.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Jun 2017 10:05:45 -0700
Message-ID: <CAPcyv4iPVD_hzNz_LzR4fLEOC4hx6c0ecdVGNzFgJVjDT0B0ZQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: daxctl: Adding io option for daxctl
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 10:00 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>
>> The daxctl io option allows I/Os to be performed between block/file to
>> and from device dax files. It also provides a way to zero a device dax
>> device.
>>
>> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>
> Does that really belong in daxctl?

I'm open to teaching other utilities how to do mmap based i/o, but is
there any harm in carrying this dedicated utility for this purpose?
Certainly the error clearing interface to send custom nvdimm ioctls is
not something I expect 'cp' or 'dd' to comprehend.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
