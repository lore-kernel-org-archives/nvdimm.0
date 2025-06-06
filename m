Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1BA17548
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 02:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749176463; cv=none; b=UhmTvSxy/jaPjPJOAqhw7PVQCPu/KS+djGVpunEbhN3UXR2cdFrs019eHGa5NH38gg4C+P9FGfJB4+EYr+AYbjbuoAyO61YbBSShlpgaJGf9CitaRz/njwxxNB4oX/e4OnePxIIfnHoPe4CooKHUWunZkIqTEQh9x3N9d9E0svs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749176463; c=relaxed/simple;
	bh=+/w+ezUf7X5NnQhZCOExbM6FaBnwc0JdGT6WrIiD79k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUkYA4a3fxroj9byQaDLCcyQ/oeRUMMQsIDHbQbN79viBmIC/q5hrmtxhywc5ZWw1wV9fkQ0VARkwBkGKBsuMZeq9SwXnI7LuzblpeY6B0blcfl60PgEO8W+LdrWMEAPG6Fg1OF8pdp/N73lnErwVXKwkSC/gBo+QY7bDkm/tOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqIVMtNw; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqIVMtNw"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so2923851a12.3
        for <nvdimm@lists.linux.dev>; Thu, 05 Jun 2025 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749176460; x=1749781260; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/w+ezUf7X5NnQhZCOExbM6FaBnwc0JdGT6WrIiD79k=;
        b=dqIVMtNwzVc+hW4Doj3mnfK4FiLXHEsevDqg2MRzS9WGTKeW8DPp3wfc9skJTRyGO/
         DGZZ1C2HwBBFmSyiDc9904hev2yKOcudQ5s0Y6au1/LfM5fBDO/utf/BzoYxV8GeuS5G
         OJEezv9g0mL5tkQv3dQ0lbk/FpNmwS+6cpqzo3Uojm9PWrPN2ABF44OrSpAXDyOec+3d
         W6fqRRlvM1VTWCrPpuIvt61sKxiCr4Wb794KPhiReSSK1UDs6nyZ433zDenL98GQeFYd
         90/fJAP9SSeU564ZD1Ri1Ki9ErBje0rm7jeT2z24gYUsTHfCS4cPM4Df3ZUggZGe3VoZ
         T/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749176460; x=1749781260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/w+ezUf7X5NnQhZCOExbM6FaBnwc0JdGT6WrIiD79k=;
        b=eItQCBKj+NOKRIt6/SVD+frRQBDIac5SozwJfY9ewuWeoRxr81uTU0c6ojqDDbtz6C
         hEQJKWwSngH6vmJVLSgt2DgY2cQ4Uu47nZWZXunv5LIEdDfETug2hGW/QlCn9AcBbm9t
         oYkf2RJQ6cIXD5dbrpg4FFpcNzLdicbTQzLBkA4K8FDE2BB3bc07YRJDr+DHC9uADUiU
         3vSndw3NKYLUFtK4Pq9PNOvzRW50YvNDrQiBhtJBYRulRf2NNVDoP13RIvfS2UVAeuZJ
         pSMWfcRgPqkYN6qGFKkcpjS+IPecuqJqEXd9vTd80qrK4TtetQf2VNb1BUhDRM2DKqm7
         PpOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVts9K7GZ2kblE7B3b+V1kcUVwc2z7FQq00QcjeikN5w+zHFO9hO7HoH1WKEEqCxYbnLWN1rDg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2RMLN+hj7+KjjYHjsGjnKril8xbwuepnGXAi0JID8onkI62PO
	Q+sItEVC54SvEZELyyZKqRYEpIt/mkV7Ng81VVJboes43P9H7uv7wMLyP41DLCELmDXFFQMMvvb
	1UV68ZI2bzaDCZhLrbiM9UUsj8u379kA5IaDc
X-Gm-Gg: ASbGncslPZTEMXMfk7wI8knCCDiJf6Uu98AiTb1HT2DTMb90afQGpnosH1fJ3at+vdX
	MH9pq1Rvj1VObI1C3B4br9LtOMCodkY9dalx6r+qWjnBUo+1mVdnx7Key4NlhF502LFIRSf6UtF
	pQ/1QEm9NxbYw1xYElTWXR3NioeADSceyi
X-Google-Smtp-Source: AGHT+IFc7VIpbhtGV5mGiNrX78q/D1h2yxz4sJe2yXc/ZDu4l9xgq48hcedhMj9dud5ev9dujOFwsPoX+nc+SkHMwjs=
X-Received: by 2002:a05:6402:524b:b0:606:bea1:1740 with SMTP id
 4fb4d7f45d1cf-60774b7bc65mr1128147a12.30.1749176460253; Thu, 05 Jun 2025
 19:21:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520021440.24324-1-drew@pdp7.com> <aCvnXW12cC97amX3@x1>
 <20250520-refract-fling-d064e11ddbdf@spud> <aCzvaPQ0Z3uunjHz@x1>
In-Reply-To: <aCzvaPQ0Z3uunjHz@x1>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Fri, 6 Jun 2025 12:20:48 +1000
X-Gm-Features: AX0GCFvIt_VakDMPR7VmzL7GHuJCZDjXNytVbW5mNeBulllFm4neaxbMh2Ug6zA
Message-ID: <CAOSf1CGLoN7u18OOPZ_FGiYvxUninoCAvR8CJiOLGJrORCghdw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: pmem: Convert binding to YAML
To: Drew Fustini <drew@pdp7.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 7:08=E2=80=AFAM Drew Fustini <drew@pdp7.com> wrote:
>
> On Tue, May 20, 2025 at 04:51:42PM +0100, Conor Dooley wrote:
> > On Mon, May 19, 2025 at 07:22:21PM -0700, Drew Fustini wrote:
> > > On Mon, May 19, 2025 at 07:14:40PM -0700, Drew Fustini wrote:
> > > > Convert the PMEM device tree binding from text to YAML. This will a=
llow
> > > > device trees with pmem-region nodes to pass dtbs_check.
> > > >
> > > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > > ---
> > > > v2: remove the txt file to make the conversion complete
> > >
> > > Krzysztof/Rob: my apologies, I forgot to add v2 to the Subject. Pleas=
e
> > > let me know if I should resend.
> >
> > I see how it is Drew...
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
>
> Thanks for the Ack and sorry about that :)
>
> Is it now just a matter of Rb from Oliver O'Halloran and this patch
> going through the nvdimm tree?

It looks fine to me, but I've never worked with YAML DTs so I won't
pretend to review it.

Acked-By: Oliver O'Halloran <oohall@gmail.com>
