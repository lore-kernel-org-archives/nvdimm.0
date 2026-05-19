Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BFB3314DE;
	Tue, 19 May 2026 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191383; cv=none; b=VNY6hgyMU5u5LwHQj+M2ccbsYhLNkuI/uidieJJ5naob9bD8P1s3xtOlmsbvYjb41DfPlc6eW/KTd5eOptvE0yQE6hkgmwlghC+nVW0+fCsu+lX9nAHTtPtHCNokdOb7cGkZavQJctYwToHLNCtwVrpRCmHglj1a1QDTQ7pwzlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191383; c=relaxed/simple;
	bh=UpRjlMr0kBpQT1Dq9GKlBlF1j95+pLOSWlZJyRaJ1/A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DmZdGizhTHem93mFCW4SPOfr3IZB9/dEP6fLlobtYLcT2TB6QubNuoKtustnTPSmy+4D7a4drYeR8mS+3HdyoxSq/Hug+jhkonqdA34dZu1+kgvUtIKZqQDs2O4DKYecWmB5SEYJvyegqBiVxLLZAQvw4X71kuAZXFwHpfBCrrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lj/1iUEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lj/1iUEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7A3C2BCC7;
	Tue, 19 May 2026 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779191382;
	bh=UpRjlMr0kBpQT1Dq9GKlBlF1j95+pLOSWlZJyRaJ1/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lj/1iUElD+O+yvVtkw/ZXDNYxv9mNEwtDdW2dbU5kFm5Q9B/MuSlL2pzRqxF9HdMY
	 w+fPLIXpz8QpmiERprKOEsoom+DiaWO8t8fJoFMKpTBX0ecfeqt5GYCAs6jtyx4P7M
	 7/c5NPK1SqZf4mP975zl2d6KGCQ6AJOgKfLWZ1HRudL81k9Q098vWI584jklCzOInD
	 LLQV1KXjK1ukBH032UxgTqtTRLw/j1mNEQE71W56wD6k/8bpLyGZJgAkKnWozTsZSX
	 wvOaTRdgKLnNqrh39ImoSKhC/g853qklhlWQ65aY/5xatsUri1BOCQNBUut+lFcf8Q
	 C+P+OvBZlKmbA==
Date: Tue, 19 May 2026 12:49:34 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: alison.schofield@intel.com, dave.jiang@intel.com, guoren@kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Lucas De Marchi
 <lucas.demarchi@intel.com>
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
Message-ID: <20260519124934.6bdda161@jic23-huawei>
In-Reply-To: <20260519034849.38047-1-cp0613@linux.alibaba.com>
References: <20260518170141.215d1755@jic23-huawei>
	<20260519034849.38047-1-cp0613@linux.alibaba.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2026 11:48:47 +0800
Chen Pei <cp0613@linux.alibaba.com> wrote:

> On Mon, 18 May 2026 17:01:41 +0100, Jonathan Cameron wrote:
>=20
> > > I think this patch is worth you trying. In libmkmod code I'm looking =
at: =20
> >=20
> > It doesn't work - hence the reply!
> >  =20
> > >=20
> > > https://github.com/lucasdemarchi/kmod/blob/master/libkmod/libkmod-mod=
ule.c
> > >=20
> > > the "module directory exists but initstate cannot be opened" case ret=
urns
> > > KMOD_MODULE_BUILTIN, not KMOD_MODULE_COMING. =20
>=20
> Hi Jonathan,
>=20
> Thanks for testing and the detailed analysis.
>=20
> I wasn't able to reproduce this on my setup because the modules.builtin
> index is correctly installed, so kmod_module_get_initstate() returns
> KMOD_MODULE_BUILTIN at the first step (via kmod_module_is_builtin())
> without ever falling through to the sysfs path.
>=20
> That said, I understand the scenario =E2=80=94 developing in a VM with
> CONFIG_DEV_DAX=3Dy but without running modules_install is a perfectly
> reasonable workflow, and I agree it's worth addressing.
>=20
> However, I feel that the suggested workaround (adding a COMING +
> sysfs-dir-exists-without-initstate check in ndctl) is papering over
> what is fundamentally a libkmod issue. When a module is builtin and
> /sys/module/<name>/ exists without an initstate file, libkmod should
> not return KMOD_MODULE_COMING =E2=80=94 that state implies a module is
> actively being loaded, which is not the case for a fully initialized
> builtin driver. The root cause is that kmod_module_is_builtin() fails
> when modules.builtin is missing, and the sysfs fallback doesn't
> distinguish "builtin without initstate" from "module in transition".

Agreed. I'm curious why it was built that way.  I scraped an email address
that is hopefully the right Lucas from another thread. +CC

Brief summary is that this series was trying to avoid a message when
module load fails due to it already being loaded, or built in but some
of the files are missing (as say no modules installed).   If modules.builtin
isn't there we get return value of KMOD_MODULE_COMING as the extra is it
loaded heuristic doesn't work because the initstate file isn't there at
all.

My suspicion is this is papering over a race condition that occurs in
a normal module load -  it may not be possible to tell the difference
between COMMING and BUILTIN reliably.

>=20
> I think the proper fix belongs in libkmod: the sysfs fallback in
> kmod_module_get_initstate() should return KMOD_MODULE_BUILTIN (or at
> least not COMING) when the directory exists but initstate does not.
>=20
> For now, would it be acceptable to keep this patch as-is (covering the
> BUILTIN and LIVE cases) and note in the commit message that the
> modules.builtin index must be properly installed for the builtin
> detection to work? If there is consensus that ndctl should carry the
> workaround regardless, I'm happy to send a v2 with the additional
> COMING handling. CC Alison.
This is indeed better than current situation and given it's ultimately a
case of message suppression that seems harmless. So I don't mind this
if handing the corner case I hit is too complex.

Jonathan

>=20
> Thanks,
> Pei

