Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C6972
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 19:26:32 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d1so4032349pll.1
        for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 12:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ruau2vUQASYD5n1j7jzSnV7qIN80PgztTLEm9RSPww=;
        b=U8S1/5aGu9wD9mOtx8/k8l7gFfP9xseg2xjqzPXCA6V5KcL3e5Hm3baH9oXWU8gSsE
         54rSufgDz9RCCWGEunoPD0vXFsSb0owh0A1K4V8TAoW43zW16BEXLUG18fuzAhPQDfXN
         +Nm9vOupfFXaPWwBDxJaAqdGX/5ecFQLP3IIj6iTHQaxDvgfnEb6ciVHaElJ1trsohJf
         NDtXm8LAqt0nE8D77F4IMp+1KIEEkjDQH+arqJdIdrpp7Zezx5nuhkMS0/4KxyuJU0gZ
         BvUdnN0vIZz8ONw3ZOTzYlolaIjJuNk70Wrp4rShLD1BcnPoMDAIf8NL3I1RM5BFPLBe
         6Zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ruau2vUQASYD5n1j7jzSnV7qIN80PgztTLEm9RSPww=;
        b=XeMbSaFs84fajMWOAx9ip4Himh6Z13dvAaW20iYWak6f169AtVztgKQYpR/azMArD+
         v2/0f700CCcZhV09xDC1xKrz4LX/abYRZwXB93Jf9aNAi0yZWmH8q/mbKe4vTdtezLcj
         hjB//02aUcO4hnDq3s+vTMmVO5XkaXCgmC4tRYUBFDiAHxlJBu0U58R6tdGW8eyPuwRu
         jvVIXAJK5e7wMQ5ldJDwvWTVOpxJKsHp8SEUmGvHTthwpiKiOZ/UyHE6PAREuG/up3Rf
         JtjfPGCzLwLKCWr3ebESQB2LMsSEqgnh4BA1kPIr+Tr12BF1nWE4YKOMv0rz20GXn5qC
         BeJw==
X-Gm-Message-State: AOAM531z03681JgmbiwkvNAvOdYbjpzxs65GHkd+4pyz4uUpIPbyDXNE
	21hCSRm8QQbL7/oVSNz3P44KVAg/gzOmEGOeWvr3lA==
X-Google-Smtp-Source: ABdhPJzNpMsWvBQnmKUryWhwc8oHeJaeM1sj8NhQUM43D3SLngRPw6V+c/pyCYW/J1KAGpFGEcu7AcpK61O1AkIC8QY=
X-Received: by 2002:a65:6248:: with SMTP id q8mr252116pgv.279.1628709991955;
 Wed, 11 Aug 2021 12:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YROE48iCZNFaDcSo@smile.fi.intel.com> <YRQB9Yvh3tmT9An4@smile.fi.intel.com>
 <CAPcyv4jOEfi=RJTeOFTbvkBB+Khfzi5QirrhPxeM4J2bQXRYiQ@mail.gmail.com> <YRQik5OnRyYQAm4o@smile.fi.intel.com>
In-Reply-To: <YRQik5OnRyYQAm4o@smile.fi.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Aug 2021 12:26:21 -0700
Message-ID: <CAPcyv4iB2U4XGk2j9UJCZm42c8-MkkEpeHpsnbN7uX7-KQL8Rw@mail.gmail.com>
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 12:18 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Wed, Aug 11, 2021 at 10:11:56AM -0700, Dan Williams wrote:
> > On Wed, Aug 11, 2021 at 9:59 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Wed, Aug 11, 2021 at 11:05:55AM +0300, Andy Shevchenko wrote:
> > > > On Mon, Aug 09, 2021 at 03:28:40PM -0700, Dan Williams wrote:
> > > > > In preparation for CXL labels that move the uuid to a different offset
> > > > > in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> > > > > proper uuid_t type. That type definition predated the libnvdimm
> > > > > subsystem, so now is as a good a time as any to convert all the uuid
> > > > > handling in the subsystem to uuid_t to match the helpers.
> > > > >
> > > > > As for the whitespace changes, all new code is clang-format compliant.
> > > >
> > > > Thanks, looks good to me!
> > > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > >
> > > Sorry, I'm in doubt this Rb stays. See below.
> > >
> > > ...
> > >
> > > > >  struct btt_sb {
> > > > >     u8 signature[BTT_SIG_LEN];
> > > > > -   u8 uuid[16];
> > > > > -   u8 parent_uuid[16];
> > > > > +   uuid_t uuid;
> > > > > +   uuid_t parent_uuid;
> > >
> > > uuid_t type is internal to the kernel. This seems to be an ABI?
> >
> > No, it's not a user ABI, this is an on-disk metadata structure. uuid_t
> > is approprirate.
>
> So, changing size of the structure is forbidden after this change, right?
> I don't like this. It means we always stuck with this type to be like this and
> no change will be allowed.

You want the flexibility to make a uuid_t not a 16-byte value? Isn't
that no longer a uuid_t? However, if the answer is yes, then I agree
it can not be used in these "on-disk" structures. I would expect
uuid_t size to be as reliable as any other Linux kernel specific type
that implies a size, and I would nak a patch that tried to change
uuid_t the way you describe.

That is, if I'm understanding your concern correctly...

>
> > > > >     __le32 flags;
> > > > >     __le16 version_major;
> > > > >     __le16 version_minor;
> > >
> > > ...
> > >
> > > > >  struct nd_namespace_label {
> > > > > -   u8 uuid[NSLABEL_UUID_LEN];
> > > > > +   uuid_t uuid;
> > >
> > > So seems this.
> > >
> > > > >     u8 name[NSLABEL_NAME_LEN];
> > > > >     __le32 flags;
> > > > >     __le16 nlabel;
> > >
> > > ...
> > >
> > > I'm not familiar with FS stuff, but looks to me like unwanted changes.
> > > In such cases you have to use export/import APIs. otherwise you make the type
> > > carved in stone without even knowing that it's part of an ABI or some hardware
> > > / firmware interfaces.
> >
> > Can you clarify the concern? Carving the intent that these 16-bytes
> > are meant to be treated as UUID in stone is deliberate.
>
> It's a bit surprise to me. Do we have any documentation on that?

Documentation on these superblocks formats? Some are in EFI, some are
Linux specific.

> How do we handle such types in kernel that covers a lot of code?

I'm not following?
