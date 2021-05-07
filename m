Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DADE72
	for <nvdimm@lists.linux.dev>; Fri,  7 May 2021 01:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620351675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4j8mAAI/o5+m3p8IBcYqwPsD4sTg8s4W4APDiyUvjzk=;
	b=NZ//OU4/P9bErU7LDAvIVxJa/vxyn6UOSvSMVhxdTWqZzM/kcKpkvrbsJpjWf8ZUW1jNJn
	Aroi94mh5A/vKU2GmDVuUBHBd+aTbECMxtkpmvAIiNq9iEJ5ZR44xlNId81lyR6UISLxCX
	fhK1VkklplyOf+3tSyLTKlpHZ7kRMFY=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-o0acQTl3OgS0kgmo17WlIA-1; Thu, 06 May 2021 21:41:12 -0400
X-MC-Unique: o0acQTl3OgS0kgmo17WlIA-1
Received: by mail-yb1-f200.google.com with SMTP id l9-20020a5b0b890000b02904f7fb53ca12so8271863ybq.15
        for <nvdimm@lists.linux.dev>; Thu, 06 May 2021 18:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4j8mAAI/o5+m3p8IBcYqwPsD4sTg8s4W4APDiyUvjzk=;
        b=n998Nal16aSEDVbGuGPn1nhxeS4idXNxe6UN2xb1oa0x+htPNSKbgxvtGaMKA469qt
         n2cjohu3wBEyazoBRhwxRHoyf5XIu1BwGY6UVSW3HaA1lufJjvsOoE0mhEH+LqWX/kcu
         HfwnIZyBG180eG7vXTmRy5cNmSe4WqhjfUkECFJS+H0n9mI81kvJN8dPQDDdxroM6BJP
         B36/mY2DbGQcVDBh0F7oaKHiT/pxF8r//EZwzrjJa/otITM9FddSBercq1t1YrcrV488
         dngAUAbzT3LdjORQA1NAEREaPQ3Y0BsxBHRN6OE9/PhzMmlY73ON2+ZXS9rlclaKKsTn
         9zqA==
X-Gm-Message-State: AOAM530xl6ENHZbTgUZH8GYq0tui4YU777DmWzNm6jXosyWaejBRDtmJ
	Hr1xu1mVoItqVDVzhBs6R1ibn4rEqZAJK+k7TjNew2zfo6qmL2B2IsFFpGokUbyEznkXblONL5/
	c6tRBzy8bb/51SKNoVuSNMfW27KbsSL7B
X-Received: by 2002:a25:4093:: with SMTP id n141mr10244491yba.133.1620351672247;
        Thu, 06 May 2021 18:41:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7ozdW9iEEZnhy0Hfj1ui3nQzAyakvQKh8G3OXfmE/Ywibo3k6TbqijMUPZCw/RB1fxZYooAzH5KF2B3SiYiM=
X-Received: by 2002:a25:4093:: with SMTP id n141mr10244475yba.133.1620351672078;
 Thu, 06 May 2021 18:41:12 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHj4cs9s25EqRhL6_D5Rg_7j14N5UVODJ0ps4=4n7sZ6zE5U3w@mail.gmail.com>
 <CAPcyv4iuA=+aUOgHvYXtg8D_1RSxjrZC4cG2GXVhEZVeQCD5rA@mail.gmail.com>
 <CAHj4cs_Zp85ePses2CxuNyoh5FAObWxOuWGAmmOeZ1KOTQ6msQ@mail.gmail.com>
 <MWHPR11MB1599C0D93E6535796F3E0F21F0589@MWHPR11MB1599.namprd11.prod.outlook.com>
 <CAPcyv4g8+JHem1dJy4Hnf0eu0LfCX59u9Zta9AEXXRSa835GyA@mail.gmail.com>
In-Reply-To: <CAPcyv4g8+JHem1dJy4Hnf0eu0LfCX59u9Zta9AEXXRSa835GyA@mail.gmail.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Fri, 7 May 2021 09:41:00 +0800
Message-ID: <CAHj4cs9Xtfe8F92t8B433QFu19MaQeKnfpdti=oOC9c4e-THDg@mail.gmail.com>
Subject: Re: [bug report] system panic at nfit_get_smbios_id+0x6e/0xf0 [nfit]
 during boot
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Kaneda, Erik" <erik.kaneda@intel.com>, "Moore, Robert" <robert.moore@intel.com>, 
	linux-nvdimm <linux-nvdimm@lists.01.org>, 
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, nvdimm@lists.linux.dev
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 7, 2021 at 5:17 AM Dan Williams <dan.j.williams@intel.com> wrot=
e:
>
> On Thu, May 6, 2021 at 10:28 AM Kaneda, Erik <erik.kaneda@intel.com> wrot=
e:
> >
> >
> >
> > > -----Original Message-----
> > > From: Yi Zhang <yi.zhang@redhat.com>
> > > Sent: Wednesday, May 5, 2021 8:05 PM
> > > To: Williams, Dan J <dan.j.williams@intel.com>; Moore, Robert
> > > <robert.moore@intel.com>
> > > Cc: linux-nvdimm <linux-nvdimm@lists.01.org>; Kaneda, Erik
> > > <erik.kaneda@intel.com>; Wysocki, Rafael J <rafael.j.wysocki@intel.co=
m>
> > > Subject: Re: [bug report] system panic at nfit_get_smbios_id+0x6e/0xf=
0
> > > [nfit] during boot
> > >
> > > On Sat, May 1, 2021 at 2:05 PM Dan Williams <dan.j.williams@intel.com=
>
> > > wrote:
> > > >
> > > > On Fri, Apr 30, 2021 at 7:28 PM Yi Zhang <yi.zhang@redhat.com> wrot=
e:
> > > > >
> > > > > Hi
> > > > >
> > > > > With the latest Linux tree, my DCPMM server boot failed with the
> > > > > bellow panic log, pls help check it, let me know if you need any =
test
> > > > > for it.
> > > >
> > > > So v5.12 is ok but v5.12+ is not?
> > > >
> > > > Might you be able to bisect?
> > >
> > > Hi Dan
> > > This issue was introduced with this patch, let me know if you need mo=
re info.
> > >
> > > commit cf16b05c607bd716a0a5726dc8d577a89fdc1777
> > > Author: Bob Moore <robert.moore@intel.com>
> > > Date:   Tue Apr 6 14:30:15 2021 -0700
> > >
> > >     ACPICA: ACPI 6.4: NFIT: add Location Cookie field
> > >
> > >     Also, update struct size to reflect these changes in nfit core dr=
iver.
> > >
> > >     ACPICA commit af60199a9a1de9e6844929fd4cc22334522ed195
> > >
> > >     Link: https://github.com/acpica/acpica/commit/af60199a
> > >     Cc: Dan Williams <dan.j.williams@intel.com>
> > >     Signed-off-by: Bob Moore <robert.moore@intel.com>
> > >     Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
> > >     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >
> >
> > It's likely that this change forced the nfit driver's code to parse the=
 ACPI table so that it assumes that the location cookie field is always ena=
bled and the NFIT was parsed incorrectly. Does the NFIT table on this platf=
orm contain a valid cookie field?
> >
>
> This was my fault. When I saw the size change fly by, I should have
> remembered to go update all the places that do "sizeof(struct
> acpi_nfit_system_address)".
>
> Yi Zhang, can you give the attached patch a try:

Hi Dan
My DCPMM server boots up now with this patch, feel free to add:
Tested-by: Yi Zhang <yi.zhang@redhat.com>

