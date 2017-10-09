Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00F5C21F3C1B9
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 13:36:39 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id f3so41844349oia.2
 for <linux-nvdimm@lists.01.org>; Mon, 09 Oct 2017 13:40:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507580593.23025.79.camel@intel.com>
References: <20171006015340.29722-1-vishal.l.verma@intel.com>
 <20171006015340.29722-3-vishal.l.verma@intel.com>
 <CAPcyv4hLcpngRij-Kr+OZkK=CbHVNc_A+9qP=cgPpOxUKH3SzQ@mail.gmail.com>
 <1507580593.23025.79.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Oct 2017 13:40:05 -0700
Message-ID: <CAPcyv4gvvYGxJnkCJttEymi8NbqDZLvk0CKhdZ8x-x-P0Nb_0A@mail.gmail.com>
Subject: Re: [PATCH 2/4] nfit_test: add error injection DSMs
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 9, 2017 at 1:25 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Sat, 2017-10-07 at 10:07 -0700, Dan Williams wrote:
>> On Thu, Oct 5, 2017 at 6:53 PM, Vishal Verma <vishal.l.verma@intel.com
>> > wrote:
>
> []
>
>> >         NFIT_ARS_TIMEOUT = 90,
>> > +       NFIT_ARS_INJECT_INVALID = 2,
>>
>> If there is no usage of this define outside of nfit_test then it
>> should be defined in tools/testing/nvdimm/test/nfit.h.
>
> Yes moved.
>
>>
>> >  };
>> >
>> >  enum nfit_root_notifiers {
>> > diff --git a/tools/testing/nvdimm/Kbuild
>> > b/tools/testing/nvdimm/Kbuild
>> > index d870520..3272ab5 100644
>> > --- a/tools/testing/nvdimm/Kbuild
>> > +++ b/tools/testing/nvdimm/Kbuild
>> > @@ -69,6 +69,7 @@ libnvdimm-y += $(NVDIMM_SRC)/region_devs.o
>> >  libnvdimm-y += $(NVDIMM_SRC)/region.o
>> >  libnvdimm-y += $(NVDIMM_SRC)/namespace_devs.o
>> >  libnvdimm-y += $(NVDIMM_SRC)/label.o
>> > +libnvdimm-y += $(NVDIMM_SRC)/badrange.o
>>
>> This hunk should go in the same patch that changes
>> drivers/nvdimm/Makefile to add badrange.o so we don't have an
>> nfit_test compile breakage gap between commits.
>
> The kernel's normal usage already has the kbuild change in the right
> place (patch 1). This adds the use of badrange functions to nfit_test
> for the first time, and hence the kbuild addition here.

It's not the nfit_test usages I'm worried about. The internal calls in
libnvdimm will break. Try building tools/testing/nvdimm/libnvdimm.ko
with only patch1 applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
