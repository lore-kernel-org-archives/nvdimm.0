Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
References: <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
 <PU1P153MB0169BD9237F2DC1FA64721BABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4h0B0sBMjiAC=Tk=Mu58A4vZ5F9yUPQsXqf5jyYF37VCw@mail.gmail.com>
 <PU1P153MB0169F7C111EEC5890D3F840ABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4iMau=fvOfubDvK=cg5v5287TvXqBCm=p8nqbz2es6YEg@mail.gmail.com> <PU1P153MB0169997F36D28D8EA80923CFBF6E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169997F36D28D8EA80923CFBF6E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Feb 2019 09:11:59 -0800
Message-ID: <CAPcyv4h6xBmsO+KrJas2YcsZRayn50UVGp1Sjs3nv4+_6XwGLA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dexuan Cui <decui@microsoft.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 5, 2019 at 8:53 AM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Sunday, February 3, 2019 11:14 AM
> > > ...
> > > As I understand, the essence of the issue is: Hyper-V emulates the
> > > label mechanism (i.e. it supports _LSI and LSR), but doesn't do it
> > > right (i.e. it doesn't support _LSW).
> > >
> > > To manage the namespaces, Linux can choose to use label or not.
> > >
> > > If _LSI/_LSR are supported, Linux assumes _LSW is supported as well
> > > and chooses to use label (i.e. the label mode), but since Hyper-V doesn't
> > > support _LSW, Linux fails to change the namespace configuration.
> >
> > No, that's not quite right. The reason Linux does not see the fsdax
> > mode configuration is due to the missing "address abstraction GUID" in
> > the label produced the default Hyper-V configuration.
> Hi Dan,
> Do you mean NVDIMM_DAX_GUID?

Correct.

>
> > In label-less mode there is no "address abstraction GUID" to validate so
> > it falls back to just using the info-block directly.
> In the case of not using label storage area, as I understand the info-block
> resides in regular data storage area. Can you please tell me where exactly
> the info-block is and how its location is decided?
> And I suppose the info-block contains the NVDIMM_DAX_GUID?

The info-block always lives in the data-storage area, even with
labels. It's placed at namespace base address + 4K.

When labels are present the label gives the namespace a uuid and the
info-block "parent uuid" field must match that value. Without labels
the "parent uuid" field is unused / filled with zero's. Also with v1.2
labels the address abstraction uuid must match the info-block type.

> I'm asking because I found I lose ~500MBytes of the 32GBytes Hyper-V
> NVDIMM device, when the namespace is in fsdax mode. When it's in
> raw mode, I'm able to use all of the 32GB space.

Yes. A portion of the capacity is reserved for page structures.

https://lwn.net/Articles/656197/
