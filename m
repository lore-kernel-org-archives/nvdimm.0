Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B561695
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 22:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nx9edqpM"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1cfc985c92dso13741665ad.0
        for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 14:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701381664; x=1701986464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LerepnGMUiOXT/0UGMgfJC9H+FWGcQr9/NrsSWwAYiw=;
        b=nx9edqpMd5GXP5RpCzR9tCvz4U+FO9OR6vByBjniw7FLUH4fyXrFf+iedgOTCsprqf
         ZvDuV0QAbTj8L8dXZm6xeDGyPkipSJeLykfwGMzH1gsrAGdbpn/Ha1/aXwkikeRY7EdH
         jYS59+ih0Z9wVRVstfwc9qkvZiv4ohdSkKIV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701381664; x=1701986464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LerepnGMUiOXT/0UGMgfJC9H+FWGcQr9/NrsSWwAYiw=;
        b=exf8DyNfZJaBH3Hyr+sancFbhPgQEca+fNr8auHy//5LhkcLU3JFf4myDvAWLB+TiN
         bDDbFns1lykzlriQVN07+dl9FfnHqB0Mk6NTqRiaEs2dKr2TPkmCiHV8kYlUz1DypOfi
         THsYkMfvircPfaQHI07Uf/ZiiW3DKgotxo8X9MVr/1LwadzuYToDWikELddr0lMmKwSU
         kDcronykYqhDtWkBZd3TcuFlYrXGrsXO6NrIAaHqJ86pUnANfy4c5t0hTBuchb7D/39C
         ll3Zg5C1PiBH9bEzBvayICb6ei9VyjoVatFkr6kMdChjvgqqJRNvt/l5sbrofhfRXz+z
         S0uQ==
X-Gm-Message-State: AOJu0YyBRxojFr9z28AcRo9Ks7uyvvyYQE7pptZZ8mljewRyKMLeWMif
	96mB1qtlXJNq7/gszpiuXa22IQ==
X-Google-Smtp-Source: AGHT+IGXEBsq8mJGgfRrzCqpP9iVTEjhPsI63xlSBWuqXIohnExKvOFH6N2uRWv3F1zWbr5pMAWXTw==
X-Received: by 2002:a17:902:7045:b0:1cf:b4a3:adae with SMTP id h5-20020a170902704500b001cfb4a3adaemr17178400plt.44.1701381664185;
        Thu, 30 Nov 2023 14:01:04 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902650b00b001c71ec1866fsm1910128plk.258.2023.11.30.14.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 14:01:03 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] nvdimm/btt: replace deprecated strncpy with strscpy
Date: Thu, 30 Nov 2023 14:01:01 -0800
Message-Id: <170138165969.3649414.1104286704035557609.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231019-strncpy-drivers-nvdimm-btt-c-v2-1-366993878cf0@google.com>
References: <20231019-strncpy-drivers-nvdimm-btt-c-v2-1-366993878cf0@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 19 Oct 2023 17:54:15 +0000, Justin Stitt wrote:
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
> [...]

Applied to for-next/hardening, thanks!

[1/1] nvdimm/btt: replace deprecated strncpy with strscpy
      https://git.kernel.org/kees/c/26b4ca3c3901

Take care,

-- 
Kees Cook

