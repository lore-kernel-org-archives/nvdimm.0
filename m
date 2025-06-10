Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C31624E5
	for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 02:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521448; cv=none; b=ft5IEGkGEKDDBNJbi1+uB+4efikryly9jVbfp6AQBtiTjyzY2V8F8682PZW+LEXXsBj9Pol3uAZA89yzqlhpPL8efx+vuLE96Q/e/4iujb1awWiqo4crpZRsnNtR/V3NuIbqraP7k4/3bgqmK6VJ0xvRBEmFxnbiQF8joQLEAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521448; c=relaxed/simple;
	bh=5aU7eapGM/ei5f45aN1KDGXaOdpkZ89epyfvqNAl4eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPvCeM3ZndXoFXokao3zxEpIj/PYpshvlDmrBAJcBIeuYmVJ3SLxlJRCEA9EL/sAODw7L+43Mmyp+buXJcBHzZKr2ftVNZBdkBOYXv1mNr6zKh+rOSpFZyWaTXQeuEq3vY/umc9scaDys4mBqbGDpCRtPtHRB6v7jf3IXfnZfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=DMDN0ff6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="DMDN0ff6"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235ef62066eso61192945ad.3
        for <nvdimm@lists.linux.dev>; Mon, 09 Jun 2025 19:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1749521445; x=1750126245; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ya/YooFCKAb0uxl/VSVdQA32RSK9pJJ/D62fB+0PERk=;
        b=DMDN0ff6x5+vfrZnL+fhNK6gjivAOL6+UdDb4FZRjRpE3K2cf4NlkGeuZmAAeG6YzN
         jnbdsMLfH1VnjqFckbDcSPn89cK68stP3uQs2ZO9BsMckgrMfJQps4xcbXuYzUPmqiXw
         /ptfh2IVFCp/LeMBiCy0beZjT74R/MlcN/Eww2ghvwfymS3hOzSaph+nxTFcxSJjNk6y
         Fy9j45PsuNhmbOJUvGGp55+v5PfsBMXYta9DK+pSU1Mm5kCE5vPLSbnQ7Hgi0iDkmt/L
         p+7pbKb/Zw6DLHrQvNPJIciNqAcsDtZXdT7RIO+PYTcPeuPMA+iEdQfANKZUlll8PbiR
         LIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749521445; x=1750126245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ya/YooFCKAb0uxl/VSVdQA32RSK9pJJ/D62fB+0PERk=;
        b=kkzuUhUyUOuDs0IwNbHgPp+HX6KzpQf4n/d93OO7yE58Zz9rXtmS98hFNzrvBj4zFH
         lmQzLyjAWVits6x6HnClV5t4TyxqvCsd3SJr+NhC3cswIHPA3eZHY6b8laEqoN0FdnlH
         W3u15e5/fezE+ghtDZndszCN2PoPJc4suAI7CIP4scniI4wX6GIPffwWgI4HKNKWabqb
         nb/xt59EKb/rOcLPTmP9LUQyVH1Qn6sdt2E79xbt2Rq/xtsbtIrR6A2JQwjRKfkQG56N
         /YUcaOYb117KQ92ruXul3t1Yt5jqjcCKgM47+lqCGyClLQaDLgX2VqdPBT2d9DIcnoSD
         UiSw==
X-Forwarded-Encrypted: i=1; AJvYcCViX2iAVc9zlfMioGrTxVlWq72R+K3fisV+9o1AriB9ZFKFg5Tv4H63IZLX2DtK5FxfZUdpEJY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE4TSgd8txlyWVBBmhxCmqjEBDmUQyjVhjiUiYzcjtIzzqjW7c
	sg0Dr5XRqLwHfo9QnR9rywDFXEIbfaexzOs+6AG0Y9xsOy7GxP8b6KUYK9j5EZWzL00=
X-Gm-Gg: ASbGncvFHGLaof94jH56JIZA8p/51cdDQF2oCv6+UtwC6jdDZ10YMr9XnfQqgAoBF9Q
	w/PvcZZpVbeZ5Ben/Sw9beq923wGncfXBMUp17JCxTwJUIEwRIv7Cl5CK2i6JhboNI+kOxFLmwc
	fC3V+ZGHX4DYbqREi7S/oV4SdC4ph2gF916NzO2BOeAkRYfgvRVmtfyiMFqpR5tlbNhg/Rfn8Fp
	CmJbVCuQoQE+rRravOZ+Y7mKeZiRDSFxlHPmEOxr7o+qxH1O6EMkovrx20ke4Yab5Y1FKWBYUl5
	8CpxP3F22iaSJfX7xzyk+TaA6j0SgYvKgym21JG9EDybb3whzklacE1N4a8LJw2Eut/U15mly/z
	liCxPv5he
X-Google-Smtp-Source: AGHT+IHiLzOREAtFVISmftxMjRL3+S4jCj4+M1zY33h7bufBc03vR1T1goruVVU0oe6Aj5IJJ3iEbg==
X-Received: by 2002:a17:903:f87:b0:236:15b7:62e8 with SMTP id d9443c01a7336-23638331c1emr13447465ad.25.1749521445312;
        Mon, 09 Jun 2025 19:10:45 -0700 (PDT)
Received: from x1 (97-120-245-201.ptld.qwest.net. [97.120.245.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603078175sm60500825ad.9.2025.06.09.19.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 19:10:44 -0700 (PDT)
Date: Mon, 9 Jun 2025 19:10:42 -0700
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
Message-ID: <aEeUInXN6U40YSog@x1>
References: <20250606184405.359812-4-drew@pdp7.com>
 <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
 <6846f03e7b695_1a3419294dc@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6846f03e7b695_1a3419294dc@iweiny-mobl.notmuch>

On Mon, Jun 09, 2025 at 09:31:26AM -0500, Ira Weiny wrote:
> Dan Williams wrote:
> > [ add Ira ]
> > 
> > Drew Fustini wrote:
> > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > device trees with pmem-region nodes to pass dtbs_check.
> > > 
> > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > ---
> > > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > > through the nvdimm tree?
> > 
> > Ira has been handling nvdimm pull requests as of late. Oliver's ack is
> > sufficient for me.
> > 
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > @Ira do you have anything else pending?
> > 
> 
> I don't.  I've never built the device tree make targets to test.
> 
> The docs[1] say to run make dtbs_check but it is failing:
> 
> $ make dtbs_check
> make[1]: *** No rule to make target 'dtbs_check'.  Stop.
> make: *** [Makefile:248: __sub-make] Error 2

I believe this is because the ARCH is set to x86 and I don't believe
dtbs_check is valid for that. I work on riscv which does use device tree
so I use this command:

make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- dtbs_check


> 
> 
> dt_binding_check fails too.
> 
> $ make dt_binding_check
>   SCHEMA  Documentation/devicetree/bindings/processed-schema.json
> Traceback (most recent call last):
>   File "/usr/bin/dt-mk-schema", line 8, in <module>
>     sys.exit(main())
>              ~~~~^^
>   File "/usr/lib/python3.13/site-packages/dtschema/mk_schema.py", line 28, in main
>     schemas = dtschema.DTValidator(args.schemas).schemas
>               ~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
>   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 373, in __init__
>     self.make_property_type_cache()
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
>   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 460, in make_property_type_cache
>     self.props, self.pat_props = get_prop_types(self.schemas)
>                                  ~~~~~~~~~~~~~~^^^^^^^^^^^^^^
>   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 194, in get_prop_types
>     del props[r'^[a-z][a-z0-9\-]*$']
>         ~~~~~^^^^^^^^^^^^^^^^^^^^^^^
> KeyError: '^[a-z][a-z0-9\\-]*$'
> make[2]: *** [Documentation/devicetree/bindings/Makefile:63: Documentation/devicetree/bindings/processed-schema.json] Error 1
> make[2]: *** Deleting file 'Documentation/devicetree/bindings/processed-schema.json'
> make[1]: *** [/home/iweiny/dev/linux-nvdimm/Makefile:1522: dt_binding_schemas] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> How do I test this?

dt_binding_check should work on x86. Maybe you don't have dtschema and
yamllint installed?

You should be able to install with:

pip3 install dtschema yamllint

And run the binding check with:

make dt_binding_check DT_SCHEMA_FILES=pmem-region.yaml

You should see the following output:

  SCHEMA  Documentation/devicetree/bindings/processed-schema.json
  CHKDT   ./Documentation/devicetree/bindings
  LINT    ./Documentation/devicetree/bindings
  DTEX    Documentation/devicetree/bindings/pmem/pmem-region.example.dts
  DTC [C] Documentation/devicetree/bindings/pmem/pmem-region.example.dtb

Thanks,
Drew
