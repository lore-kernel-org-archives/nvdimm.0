Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E69F7A
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 17:28:03 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id j17so10939955pfi.9
        for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 10:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OjNNj2h0H9BdL9f5m+RhS3iK90tZuCfxF3PYDW2jHLo=;
        b=Y4suICBQDJxf0jQtkeyC3zyUM3bJCKEEvMlhWiNcQGzmHv6AX00nag852PsZfn/2WY
         QX3PVo+C07/bFjX7RsJyx8FIa8FTgD/N2sYKBiWOpN2jEIWRzzbv5Cd0J8GEUpLILWe1
         kYOvssQac95PDPJANkwqEueJuzNVkyZfGUdeSyiSdjU3+KTpuB7qjofvFpgq9PTG962L
         iY5fl8f1dAKPE5sSN/uu+Ln8TWXq9VgcVzyZH71ov5mgjuJl8PBt0nZSjXlPmLC7OVUu
         Lx53yMbickS/RVM/xs9BR4dNxqU3PNoknFTU3wQfaMkFAgIKpRIeULxaBE48sPeUDaIW
         D2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjNNj2h0H9BdL9f5m+RhS3iK90tZuCfxF3PYDW2jHLo=;
        b=vhCjGK1Pygc88gHXFjsQcdt66i/WsSOFVMH61UeVqhZ4M2JLki3ZW24Lg8f7RL05/5
         vJ33H1uQneoJ5psKpHGFyi1V16NRB44Dw6TCv69aKy+d0xJBrkAiGON95oUOhZuy0iW7
         nupbZfYEwOWXDBm2oYjQUqo7O4f56fd/SfDvH38t0RwGMF8+hkPjE4r4SN3khimoKxB/
         N8vnCqjsHP/tfjjqDSV2oXi6TQgx+l9iDq3gNgz1tjHmw+WcF6SXF/Lr9HhnYgmz2pbT
         J5ZnEvlcb8QFDUhAHyfcfWsKmxdTGKjjJN5DZ4GxHY1eWrPA+HOPqGquyRsC5BclenLO
         Opjg==
X-Gm-Message-State: AOAM5310BtwlwJ25+DW+TIbbwb9EIxYUjkAT2MtkFh2kn4YvaIyWw8r9
	HTbDc77eeI157qusFkLHuiWMj6hWT3fD6kCQiwTfxA==
X-Google-Smtp-Source: ABdhPJwT11ZC6iXsaztYnSq4YzfDM6EFxQy96NZsDhLdWGx609R+suZlfO9ayXNZmrfnqdz2ibDw7UZSkJUIhziL3i8=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr8862901pgl.40.1650734883122; Sat, 23
 Apr 2022 10:28:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YmNBJBTxUCvDHMbw@iweiny-desk3> <CAPcyv4jtNgfjWLyu6MtBAjwUiqe2qEBW802AzZZeg2gZ_wU9AQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jtNgfjWLyu6MtBAjwUiqe2qEBW802AzZZeg2gZ_wU9AQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Apr 2022 10:27:52 -0700
Message-ID: <CAPcyv4hhD5t-qm_c_=bRjbJZFg9Mjkzbvu_2MEJB87fKy3hh-g@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] cxl/acpi: Add root device lockdep validation
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 22, 2022 at 5:08 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Apr 22, 2022 at 4:58 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > On Thu, Apr 21, 2022 at 08:33:18AM -0700, Dan Williams wrote:
> > > The CXL "root" device, ACPI0017, is an attach point for coordinating
> > > platform level CXL resources and is the parent device for a CXL port
> > > topology tree. As such it has distinct locking rules relative to other
> > > CXL subsystem objects, but because it is an ACPI device the lock class
> > > is established well before it is given to the cxl_acpi driver.
> >
> > This final sentence gave me pause because it implied that the device lock class
> > was set to something other than no validate.  But I don't see that anywhere in
> > the acpi code.  So given that it looks to me like ACPI is just using the
> > default no validate class...
>
> Oh, good observation. *If* ACPI had set a custom lock class then
> cxl_acpi would need to be careful to restore that ACPI-specific class
> and not reset it to "no validate" on exit, or skip setting its own
> custom class. However, I think for generic buses like ACPI that feed
> devices into other subsystems it likely has little reason to set its
> own class. For safety, since device_lock_set_class() is general
> purpose, I'll have it emit a debug message and fail if the class is
> not "no validate" on entry.
>

So this turned out way uglier than I expected:

 drivers/cxl/acpi.c     |    4 +++-
 include/linux/device.h |   33 +++++++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 9 deletions(-)

...so I'm going to drop it and just add a comment about the
expectations. As Peter said there's already a multitude of ways to
cause false positive / negative results with lockdep so this is just
one more area where one needs to be careful and understand the lock
context they might be overriding.
