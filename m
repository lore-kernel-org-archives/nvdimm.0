Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB6D1C3306
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 02:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747707745; cv=none; b=P4OqZnmsS7ICej2Zr91GWhY3bqjJf7FG9+t+45Cl3UZ0vbXAyltN2bOSDFf+9E9+ijCr0Ox8sxP7WWTsuNWtuQ4wMS2YHdzWs8o6x9Lw4M9nBvBm0eVZT6ty3waThjVZ/KsB4d6q0wxczNrfOyQjpuwiE9UL/GxBtpLq4hV6bew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747707745; c=relaxed/simple;
	bh=jmXrTHnVLLq/i/PxF7Fe3GkUyb8o/LpC3K9yRXSmslk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjmOlHCCRokficGcNyTT5JdXvWSJP7hSCCsRtUuSU1Ieaetjl1jEkXe8GzYZD3r3dEvUg28bKIxB4ZQGlZERAhz6PV9v2hS8IPElyOSUkPSLeQBiyDW0roZBDirRM3sLN5A9sj/1rJqoClxFyhbJAZ9D+xmZMqrVF6j0oq0p7kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=oOhTNrIy; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="oOhTNrIy"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b26d7ddbfd7so5368382a12.0
        for <nvdimm@lists.linux.dev>; Mon, 19 May 2025 19:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1747707743; x=1748312543; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0x1pMRaRiUXRU9jlmtdQiRSbIB2PaGoK9fRSAZ7jcdo=;
        b=oOhTNrIy/s2C2ORyHlEkA84U8+PXUscSiaAurb0b6E+gW4uK3PFGBnSz9txqwHMEwS
         FIsHPwQLaonYOqqHVeaAsKLQx3267iy0L0OjKhcx957QVy2AQNZodrab+cVTd5FgtZ3D
         0Is6PgV+gnYQO1eM2W7qU3g4KXqNrTmCq0W6WBGLnKlgEYW6OcCqC6Ss7o8F9KaPn/Kb
         bf8+S2+ZgxYGN9WB5dOfQFt0JnExlETfB9ecySXnikNbP2s6QCG1CxexvER16GAkPEpt
         eUGaWLku5nT9Y0I9dz21rjtLNTD2ik6rT9zXOBotcwagVAmcSS3paOdvu6yIpDvWtnck
         oI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747707743; x=1748312543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0x1pMRaRiUXRU9jlmtdQiRSbIB2PaGoK9fRSAZ7jcdo=;
        b=N6itt/zLv1P8+eblFtdWjxeqJUSaI8WIDtgU3dlOpDi+kpC9IoL06r0cV2oncEY5ZA
         jDWBoRXVSGBEBimtkqPrRVHh9FiodCfzXJmxcguuw/QI0Yj/Gze66f4aLNh5z3Jn+vhP
         pqNxqxC8zCWnfaNuEHy7F5dqEAqNoHheUbjEmjerxFniswkb5amZK9V2C1sEUfpvCURZ
         OjNzdeBJ0e4vpRqh9AfzGAD8URqTM2f66jYtdN3llFz3jiQOj9vg4UddJzUeNpAm4Oxc
         larj+Fy43Y1DXpeAfot2ffp3L4iKAVQPJGhhJ/NS/vOJcvAycbVEGEcFkBcg+yvEwqxn
         ukog==
X-Forwarded-Encrypted: i=1; AJvYcCW60iSW7Caa6d5WZTmRF7KgpBkPFZJRnR5qQkCbPLpmiQc/D2YJrU8pMkmxMQRFb84jeazuFTg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4Loz4VPPYDJA1r3xvFur7iAJ+XpYr1EuIBsmwEQynN7nRAzIp
	8oUEP8V9TJppIL2AuddSshUuCU+Ap9VgqvRLeX/wHg3uwyg1PciWfdzCEBNzFtjaUCU=
X-Gm-Gg: ASbGncu1UCZNwsSZTfSbSTD/zYv3JgK8x16Ve3DrdOhE1fFBqqL/QJ2cMQOCMmkMs8t
	T0ATiYTInGtp0DpL6DP3ghwiw3ysbbBSZ+lCX9MaFJlpS08HKBo1mDMGUQyz2pBB50aLDiRbqj0
	kKRlAnWzIPx/07ace2Ea8aU0IOsNqxBuemr+myItGagEnBCLsEKNJp1UNuQNe6CY2zAX813kaYr
	3iNk06MigC/T+dYUnJKgk4ujLNf+Sek8swTAPTZhEmMJ5AOw9Y4uqcaed6SuN+oXpVf3zsjC0nn
	XxFVR1cItYjncOqv49AsEpWFdsaUyMyqgeSEEPp/mOWNaWij+qh/jNk4JZRZF5D4GyN8zfxbGw=
	=
X-Google-Smtp-Source: AGHT+IFL505dYK5kP0RzEBvKLWhjueG80hANUDXQg8Vm6xat3akzB1GhSjsarMMmvWhb64KnIqDstg==
X-Received: by 2002:a17:903:b8f:b0:224:c76:5e57 with SMTP id d9443c01a7336-231d459bee3mr202331325ad.39.1747707743271;
        Mon, 19 May 2025 19:22:23 -0700 (PDT)
Received: from x1 (97-120-251-212.ptld.qwest.net. [97.120.251.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4adb71dsm66926355ad.62.2025.05.19.19.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 19:22:22 -0700 (PDT)
Date: Mon, 19 May 2025 19:22:21 -0700
From: Drew Fustini <drew@pdp7.com>
To: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aCvnXW12cC97amX3@x1>
References: <20250520021440.24324-1-drew@pdp7.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520021440.24324-1-drew@pdp7.com>

On Mon, May 19, 2025 at 07:14:40PM -0700, Drew Fustini wrote:
> Convert the PMEM device tree binding from text to YAML. This will allow
> device trees with pmem-region nodes to pass dtbs_check.
> 
> Signed-off-by: Drew Fustini <drew@pdp7.com>
> ---
> v2: remove the txt file to make the conversion complete

Krzysztof/Rob: my apologies, I forgot to add v2 to the Subject. Please
let me know if I should resend.

Thank you,
Drew
