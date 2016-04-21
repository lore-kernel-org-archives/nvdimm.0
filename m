Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0D561A1F70
 for <linux-nvdimm@lists.01.org>; Thu, 21 Apr 2016 04:39:46 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id k142so79230136oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 21 Apr 2016 04:39:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4icU6=7UX_YD7SyqkioN+uT5KxPhm6YC_8FDE7gMFnAdA@mail.gmail.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4i4hh3PYjDk823u4rnqHB-Xh=1V19pxLUXAF0JyJiyvLA@mail.gmail.com>
 <20160420164647.GA29474@tevye.fc.hp.com>
 <CAPcyv4hM6QRth5t=Sqmo7qGZuoO0_hpFBvcp6GpYoqgS8Hdq2A@mail.gmail.com>
 <20160420225545.GD29474@tevye.fc.hp.com>
 <CAPcyv4icU6=7UX_YD7SyqkioN+uT5KxPhm6YC_8FDE7gMFnAdA@mail.gmail.com>
Date: Thu, 21 Apr 2016 04:39:46 -0700
Message-ID: <CAPcyv4jo4KKh8P-F=3VmCH8tbNX3skBOSPwEYnf=+GSaKdVirQ@mail.gmail.com>
Subject: Re: [RFC v9 1/5] nvdimm: Add IOCTL pass thru functions
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 20, 2016 at 6:29 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Apr 20, 2016 at 3:55 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
[..]
>>> > Disagree.  We've discussed this previously.  The passthru interface needs
>>> > to handle the case where the caller doesn't know in advance the size
>>> > of the return.  These cases are not errors, just a different semantic.
>>>
>>> I don't think the passthru interface deserves a different semantic.
>>> It does handle the case that the caller does not know the size, it
>>> returns -errno on too small, 0 on just right, and postive number on
>>> too big.
>>
>> I was using semantic in context of the underlying FW call.
>> HPE fw has different semantics from Intel's fw.
>>
>> -ENXIO is overloaded.  More than one type of calling "error" could
>> produce that return code.  As such, user can't rely upon the contents of
>> of payload to determine what correct size should be as user doesn't know
>> why -ENXIO was returned.
>
> Ah, yes, this is indeed convincing.  Ok, keep it where it is at.
> Apologies for making you argue that that again I had re-overlooked
> that aspect since the last time we discussed this.

Btw, please include this explanation as a comment in the code so
future readers don't try to reconcile the difference and come to the
wrong conclusion like I happened to do... twice.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
