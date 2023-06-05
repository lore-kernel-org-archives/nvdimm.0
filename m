Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117796FC3
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 17:07:57 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-977fae250easo12103466b.1
        for <nvdimm@lists.linux.dev>; Mon, 05 Jun 2023 10:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685984876; x=1688576876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZGakePAKwplYG/llAo4FkXZmbuykUNqGGuE67aJlhQ=;
        b=lrg/t58PSWKHrNNn3mPUZpfdZ+0Do6qrhg2hSGVc79yMAF6CKtNdBGuUUn2dFRAUOO
         XzvTIwB7J0ktahIFc9IhPR9JXMF56XFbeFYoJg4bR3PrnRq7SReN7bQ8OoKiMS9d9PWs
         VNw1FCVjaQomLmRIcHPtsojt3mxyGhXx+XfBRpEVSENajfGqD2iJ7KHbMLr3951AnpxG
         JwZ9FPs+ShrHN5JdDQLoDtXpzvhEpeUdmPEcJrcFPOYq2Xg1jvmgmxFwZ/JaTdl9o23s
         cW3cTkyAXajcPlUWdqIJIvhouchmFJHBiHNDkOG1mkIL1ZUtIVjzF9fpaWS6LWwkZ2AZ
         8dIg==
X-Gm-Message-State: AC+VfDwNxqjphaMH8K3hkz0rmNW26VKV/AQTkN23r3g6wITJc15rp2p+
	2IKLp8kEB2duNf2tV0qQCCa47ZAwyEy5xsyBLbym5nzm
X-Google-Smtp-Source: ACHHUZ4y6QX2tq8E27by6YkCxR3PmJMiktMABs4n4JVAUpCSd+lhY388IXN+mErboDW/wtCtUakJxEJ57qmSY1TQ/Zc=
X-Received: by 2002:a17:906:778a:b0:977:ead3:c91 with SMTP id
 s10-20020a170906778a00b00977ead30c91mr1215071ejm.1.1685984875965; Mon, 05 Jun
 2023 10:07:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230516201415.556858-1-arnd@kernel.org> <780579b5-3900-da14-3acd-a4d24e02e4ba@intel.com>
In-Reply-To: <780579b5-3900-da14-3acd-a4d24e02e4ba@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 5 Jun 2023 19:07:44 +0200
Message-ID: <CAJZ5v0hPLnFmWiv2DHh=U0FHkeu0A8yTwz7Mn8=jfenrP6wFGA@mail.gmail.com>
Subject: Re: [PATCH 1/3] acpi: nfit: add declaration in a local header
To: Dave Jiang <dave.jiang@intel.com>, Arnd Bergmann <arnd@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Len Brown <lenb@kernel.org>, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 5:22=E2=80=AFPM Dave Jiang <dave.jiang@intel.com> w=
rote:
>
>
>
> On 5/16/23 1:14 PM, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The nfit_intel_shutdown_status() function has a __weak defintion
> > in nfit.c and an override in acpi_nfit_test.c for testing
> > purposes. This works without an extern declaration, but causes
> > a W=3D1 build warning:
> >
> > drivers/acpi/nfit/core.c:1717:13: error: no previous prototype for 'nfi=
t_intel_shutdown_status' [-Werror=3Dmissing-prototypes]
> >
> > Add a declaration in a header that gets included from both
> > sides to shut up the warning and ensure that the prototypes
> > actually match.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Applied as 6.5 material, thanks!

> > ---
> >   drivers/acpi/nfit/nfit.h | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> > index 6023ad61831a..573bc0de2990 100644
> > --- a/drivers/acpi/nfit/nfit.h
> > +++ b/drivers/acpi/nfit/nfit.h
> > @@ -347,4 +347,6 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_=
desc, struct nvdimm *nvdimm,
> >   void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct dev=
ice *dev);
> >   bool intel_fwa_supported(struct nvdimm_bus *nvdimm_bus);
> >   extern struct device_attribute dev_attr_firmware_activate_noidle;
> > +void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem);
> > +
> >   #endif /* __NFIT_H__ */
