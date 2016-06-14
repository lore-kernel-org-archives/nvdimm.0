Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8084A1A1E2E
 for <linux-nvdimm@lists.01.org>; Tue, 14 Jun 2016 00:31:23 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id d132so140163410oig.1
 for <linux-nvdimm@lists.01.org>; Tue, 14 Jun 2016 00:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hnKRc6qrPPuKo1r3=YmuAAaeSSv7xBOpDMAy5UuUhoHw@mail.gmail.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
 <1465861755.3504.185.camel@hpe.com>
 <CAPcyv4hnKRc6qrPPuKo1r3=YmuAAaeSSv7xBOpDMAy5UuUhoHw@mail.gmail.com>
Date: Tue, 14 Jun 2016 00:30:58 -0700
Message-ID: <CAPcyv4jjaRBCuX3=8w-Yun79SZ25kp553Nc_WT5KBoPKq81bnw@mail.gmail.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 13, 2016 at 5:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Jun 13, 2016 at 4:59 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Mon, 2016-06-13 at 16:18 -0700, Dan Williams wrote:
>>> Thanks Toshi!
>>>
>>> On Mon, Jun 13, 2016 at 3:21 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>> >
>>> > This patch-set adds DAX support to device-mapper dm-linear devices
>>> > used by LVM.  It works with LVM commands as follows:
>>> >  - Creation of a logical volume with all DAX capable devices (such
>>> >    as pmem) sets the logical volume DAX capable as well.
>>> >  - Once a logical volume is set to DAX capable, the volume may not
>>> >    be extended with non-DAX capable devices.
>>>
>>> I don't mind this, but it seems a policy decision that the kernel does
>>> not need to make.  A sufficiently sophisticated user could cope with
>>> DAX being available at varying LBAs.  Would it be sufficient to move
>>> this policy decision to userspace tooling?
>>
>> I think this is a kernel restriction.  When a block device is declared as
>> DAX capable, it should mean that the whole device is DAX capable.  So, I
>> think we need to assure the same to a mapped device.
>
> Hmm, but we already violate this with badblocks.  The device is DAX
> capable, but certain LBAs will return an error if direct_access is
> attempted.

Nevermind, for this to be useful we would need to fallback to regular
mmap for a portion of the linear span.  That's different than the
badblocks case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
