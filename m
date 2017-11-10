Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2206821B00DC3
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 09:46:51 -0800 (PST)
Received: by mail-ot0-x235.google.com with SMTP id j29so5381947oth.13
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 09:50:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
 <CAOSf1CFMsPwFcO6Mp4fV+faEBdG5wwi3d1nGK+n-MDGF4v0oLw@mail.gmail.com>
 <x498tfe8820.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jJ0J4EkD95OXRWOogyV0tbY_WaO9WyQULL3bs+rShQBA@mail.gmail.com>
 <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Nov 2017 09:50:53 -0800
Message-ID: <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
Subject: Re: [PATCH] daxctl: remove libpmem dependency
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
Cc: "Plewa, Lukasz" <lukasz.plewa@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 10, 2017 at 8:42 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>>> I don't know, is it impossible to make this work w/o yanking out -lpmem?
>>
>> My preference would be that allthe  pmem_memcpy* routines move to
>> libndctl since it is the lower level library. Arrange for nvml to
>> depend on libdnctl for this in addition to the other libndctl
>> dependencies that seem to be in the works.
>
> That's fine by me.  Can you convince the nvml developers to do that?
>

The other concern is that libpmem supports other OSes, but libndctl is
just Linux. That seems to suggest we need the memcpy routines to be
their own standalone library that both ndctl and libpmem can import.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
