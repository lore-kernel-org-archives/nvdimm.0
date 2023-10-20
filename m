Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3C198
	for <nvdimm@lists.linux.dev>; Fri, 20 Oct 2023 00:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GR5KT3gh"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c9d922c039so2068885ad.3
        for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 17:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697761122; x=1698365922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZZ1hSxhCzr3d9ET3rkLHcUQIIjWMOt3bcRQEdfBrZs=;
        b=GR5KT3ghdO8Oe3fN6ZSAKvn4SUhIXgiX1PKQMJSWIbM5OReHl2SVm5Jnz2Cd5cSs4q
         BBN6qSPlLshvyxBVbTIiafJV+N9JkAbhPZP/83aUD9gXZxIeAimT/GaNBUV1Aj7GfVcS
         pyvJ2Rw3WgQApTYril7RlIW6Csh8HDYThcnUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697761122; x=1698365922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZZ1hSxhCzr3d9ET3rkLHcUQIIjWMOt3bcRQEdfBrZs=;
        b=WFPW43U+VExUX1L31EjnKbuB3iVbha3T5Fh8iBmdKMoo/GSIEz+5XfYJOv97fAgrwO
         KIAl4V5BtklgKkkJ+utaYTppA7MQ4PCV9RH7uY/cwJQ3ESrx07wBJORo+KJiYEZWqf7K
         GM7fnNEYUJHxZN2lr+5T008bq8RD7JJBHvoO6ZKu5PIj0h5y5QiJvdnuBMYQu1W458/r
         APKwJYchTF369+mNdMDc7Ps5KvaBQFGiDTNWK1LS4OGsVcN3loPW+EeD466B+520FLjF
         hxmwRLPpzPiUbCrGJ9sCVS44VoItRiCr4PEbhCylMzWyX0N4vYT40Pp7JDPrQC07+S7S
         8hYQ==
X-Gm-Message-State: AOJu0YzrJPawGMnf7BqS+N+uZGiQq/z45qipoCS/C9eyroiMzPwHT/VB
	CjW2CyLPiDKTw94pG6Kg/GGpXQ==
X-Google-Smtp-Source: AGHT+IEan1bQNWQMUIjClc+3tR651FQP0/DjA+XDLcE8v6xLwIt1fxOEA+DG6SlVjlc8mlA6cnRaJQ==
X-Received: by 2002:a17:903:610:b0:1c9:ec98:217 with SMTP id kg16-20020a170903061000b001c9ec980217mr403036plb.41.1697761122385;
        Thu, 19 Oct 2023 17:18:42 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l20-20020a170903005400b001bba7aab822sm299141pla.5.2023.10.19.17.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 17:18:41 -0700 (PDT)
Date: Thu, 19 Oct 2023 17:18:41 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] nvdimm/btt: replace deprecated strncpy with strscpy
Message-ID: <202310191718.4F728D9@keescook>
References: <20231019-strncpy-drivers-nvdimm-btt-c-v2-1-366993878cf0@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019-strncpy-drivers-nvdimm-btt-c-v2-1-366993878cf0@google.com>

On Thu, Oct 19, 2023 at 05:54:15PM +0000, Justin Stitt wrote:
> Found with grep.
> 
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect super->signature to be NUL-terminated based on its usage with
> memcmp against a NUL-term'd buffer:
> btt_devs.c:
> 253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
> btt.h:
> 13  | #define BTT_SIG "BTT_ARENA_INFO\0"
> 
> NUL-padding is not required as `super` is already zero-allocated:
> btt.c:
> 985 | super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
> ... rendering any additional NUL-padding superfluous.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Let's also use the more idiomatic strscpy usage of (dest, src,
> sizeof(dest)) instead of (dest, src, XYZ_LEN) for buffers that the
> compiler can determine the size of. This more tightly correlates the
> destination buffer to the amount of bytes copied.
> 
> Side note, this pattern of memcmp() on two NUL-terminated strings should
> really be changed to just a strncmp(), if i'm not mistaken? I see
> multiple instances of this pattern in this system:
> 
> |       if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
> |               return false;
> 
> where BIT_SIG is defined (weirdly) as a double NUL-terminated string:
> 
> |       #define BTT_SIG "BTT_ARENA_INFO\0"
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
