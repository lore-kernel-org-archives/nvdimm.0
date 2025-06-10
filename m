Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8491247298
	for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749581007; cv=none; b=F0ulh4npWqSEBIcd1EyRhjmd59GGSeWABQ8lrf80Ic71xtFHE+jGbgcC9c1PwFqFsfXURCRhOFIwCYVx7CDmjAyjNSzIw/qGRgDpnVLolUw2IOFI550e2V2XaN2Ak1AkwCaY3QMJd0tPccI6I9KEQmO/AhquKyy6FnzoA2F5wrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749581007; c=relaxed/simple;
	bh=H0nK1yRH6Fa3Tpm4vRAHHO9zV6GTdkLWgIgRr2wQc7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edt6q2UndNqfambH+0IZ1wz09cyIJrSbU2OX4nUiZogysySF+cXvxGs3tVSs4OP5xs4IDlLz4sW5Ul45c5BtnArvZaaN5DtNEUc+F/eGXnF79b7rKBYoheSYedjEKVhnK48Iy9/SpKy40WAuP3yJSoyo8U4ICVSqQ7tWhSvDPb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=1/d0/tyc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="1/d0/tyc"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-236377f00a1so11946395ad.3
        for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 11:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1749581005; x=1750185805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+lDJBueIA7ygqvnNMLa8xo7uOqi0/yR422aJm+FXmc0=;
        b=1/d0/tycdgg58fvYu6zD1DjeIF/MQSoLU4PDr1uJfzjGAL2x9Op1/Si0PC6znIZ2La
         ANKO2tqvZGI6PdjvYGlRVia8NSjzPVmOhfC23e6nP95kRrGJ+HAQ/VrDCdAnATEqhZcT
         LbW7KoKhUnynbu/pk0wkpW8SF84Fq2Xbyz+uRQF1H25twoC0qTZ8khMLBK7HEpLK4IfI
         6wQygqeaNUQQtybdoD4sWMQxPGCec4ufryPS/pKq496HFuDIgXIjObVFRMytNLLC3DWh
         IkgWDt1tP16KQ3s7TA0hEPEb9Zhm7A8QAvyTu9V6T9vDeiGXbjJgkyM5In4oVgQsvkII
         aKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749581005; x=1750185805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lDJBueIA7ygqvnNMLa8xo7uOqi0/yR422aJm+FXmc0=;
        b=UzukRSjJhNzef6u1KsOnMz/ZTUIlLcN6BdF3K5sHoZaFC5NMoW2ngLixms3CwRWmfh
         gRLB4iMDH2QaEYNXk0ebv8UgHzDzmh4TVoIJommIYzLtuSA46bi36GXT71Drzx9kSQHb
         MyTdLGdw6ozDnv0Zi3E1GAu4bu8HD7M5xRvSc7U45c3oLASELzV1LjJaoAOKTG02U4wi
         +JTcfegTy9EHm9mD1zcVPAICpPQEIa91Gg6o0qehvDwIgUYyjTkvpKUfEPfZ7rxCfYW3
         8L1Gms/eGYzRt59oOLNiOASKrcMAQbeJWLFYUMa/wMkaxPjAa9zJnsobe6R6sUrXAF5Y
         eVhg==
X-Forwarded-Encrypted: i=1; AJvYcCWXUGTFlZnNr9MfnrBaC1RfcJWyg0BZWWp7iyznjswaetfbDbItvo4Ph+xIrsIAaJDLD7kpF2c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0t/zI+TbUc7P0ixwX2C4d15cLZzXDA8RbeWIUEu8mdwQn9xey
	IC8NA0curcJdfmlT9yLuK6V6FT8oeb2MgG7x0cPl0WXTpYMCIzyZNylTdXKt3IFaeaY=
X-Gm-Gg: ASbGnctaUM5CDAzTT/s2ftrOw7f8XCpYE9Jwm9P5j/1jPe2QlZ0brOj8P0kNXqZ17z4
	CXhlIsOW/AjhIPX7scLpP8qXzFlrU4RvW23sPLS+X4OgBHlHRg63Q75fQLu6M3jdmnSPkqKmvvz
	ScYFo7kFDnYIGcw5CTvVQoRGKWK+FEjEXC52DSaWGo9S1erhuR0qF/98YEdZ/duASeonYQ3GRFR
	4HDAjSC63hCMS0D6Dd79GM/E69JY3L1P/Cq5wO0xwEhKvQlRUBGYw9C9HgbX4sdy2KGS5afpzGQ
	UkvVTDeGKXkSKKkmvNCvVSktJuXVrQ28KOzoGrwihZ2PF1UNQQMjek02zdo7zrGwpKbdNq9AEQ=
	=
X-Google-Smtp-Source: AGHT+IFsZ6Fe4BO0DoFerKCZiwMbhqQEYzPjvBgPPWjLKuOTaxg2oQ5N+H6uSTtx1zCOgQ7bs75qKg==
X-Received: by 2002:a17:902:d586:b0:234:d7b2:2aa9 with SMTP id d9443c01a7336-23641b1aa38mr4058485ad.29.1749581004938;
        Tue, 10 Jun 2025 11:43:24 -0700 (PDT)
Received: from x1 (97-120-245-201.ptld.qwest.net. [97.120.245.201])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2f5f66a977sm7190114a12.43.2025.06.10.11.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 11:43:24 -0700 (PDT)
Date: Tue, 10 Jun 2025 11:43:22 -0700
From: Drew Fustini <drew@pdp7.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aEh8yq/PVwEZ3980@x1>
References: <20250606184405.359812-4-drew@pdp7.com>
 <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
 <6846f03e7b695_1a3419294dc@iweiny-mobl.notmuch>
 <aEeUInXN6U40YSog@x1>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEeUInXN6U40YSog@x1>

On Mon, Jun 09, 2025 at 07:10:42PM -0700, Drew Fustini wrote:
> On Mon, Jun 09, 2025 at 09:31:26AM -0500, Ira Weiny wrote:
> > Dan Williams wrote:
> > > [ add Ira ]
> > > 
> > > Drew Fustini wrote:
> > > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > > device trees with pmem-region nodes to pass dtbs_check.
> > > > 
> > > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > > ---
> > > > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > > > through the nvdimm tree?
> > > 
> > > Ira has been handling nvdimm pull requests as of late. Oliver's ack is
> > > sufficient for me.
> > > 
> > > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > > 
> > > @Ira do you have anything else pending?
> > > 
> > 
> > I don't.  I've never built the device tree make targets to test.
> > 
> > The docs[1] say to run make dtbs_check but it is failing:
> > 
> > $ make dtbs_check
> > make[1]: *** No rule to make target 'dtbs_check'.  Stop.
> > make: *** [Makefile:248: __sub-make] Error 2
> 
> I believe this is because the ARCH is set to x86 and I don't believe
> dtbs_check is valid for that. I work on riscv which does use device tree
> so I use this command:
> 
> make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- dtbs_check
> 
> 
> > 
> > 
> > dt_binding_check fails too.
> > 
> > $ make dt_binding_check
> >   SCHEMA  Documentation/devicetree/bindings/processed-schema.json
> > Traceback (most recent call last):
> >   File "/usr/bin/dt-mk-schema", line 8, in <module>
> >     sys.exit(main())
> >              ~~~~^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/mk_schema.py", line 28, in main
> >     schemas = dtschema.DTValidator(args.schemas).schemas
> >               ~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 373, in __init__
> >     self.make_property_type_cache()
> >     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 460, in make_property_type_cache
> >     self.props, self.pat_props = get_prop_types(self.schemas)
> >                                  ~~~~~~~~~~~~~~^^^^^^^^^^^^^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 194, in get_prop_types
> >     del props[r'^[a-z][a-z0-9\-]*$']
> >         ~~~~~^^^^^^^^^^^^^^^^^^^^^^^
> > KeyError: '^[a-z][a-z0-9\\-]*$'
> > make[2]: *** [Documentation/devicetree/bindings/Makefile:63: Documentation/devicetree/bindings/processed-schema.json] Error 1
> > make[2]: *** Deleting file 'Documentation/devicetree/bindings/processed-schema.json'
> > make[1]: *** [/home/iweiny/dev/linux-nvdimm/Makefile:1522: dt_binding_schemas] Error 2
> > make: *** [Makefile:248: __sub-make] Error 2
> > 
> > How do I test this?
> 
> dt_binding_check should work on x86. Maybe you don't have dtschema and
> yamllint installed?
> 
> You should be able to install with:
> 
> pip3 install dtschema yamllint
> 
> And run the binding check with:
> 
> make dt_binding_check DT_SCHEMA_FILES=pmem-region.yaml
> 
> You should see the following output:
> 
>   SCHEMA  Documentation/devicetree/bindings/processed-schema.json
>   CHKDT   ./Documentation/devicetree/bindings
>   LINT    ./Documentation/devicetree/bindings
>   DTEX    Documentation/devicetree/bindings/pmem/pmem-region.example.dts
>   DTC [C] Documentation/devicetree/bindings/pmem/pmem-region.example.dtb
> 
> Thanks,
> Drew

I'm also on libera.chat [1] irc as drewfustini. There is a #devicetree
channel where we should be able to get things sorted quickly if you are
still getting those errors.

Thanks,
Drew

[1] https://libera.chat/
