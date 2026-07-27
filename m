Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405761A6832;
	Mon, 27 Jul 2026 12:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154574; cv=none; b=GeHq57Biwbv29WYVNeqqXL1BDMqZ9En6LuM27aMzCexuWKIdWkbag4Nlukc5mQ2Kah6YocYh0cjKjdrK90Coe4sUenxAqoPyPEi9SbD1f3HAU15Q2z1lMF3tEmdtdE6dMWuCw1H1LLsg2YWEs10AKkLY4rgh1iIRlDi6ezfciXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154574; c=relaxed/simple;
	bh=uV7Kh0keWGtMQgsG+PNorS/B1ycaHiShJ+Qvn6az7HY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cN3KUYuQg+Zot7SvgSJu0mYr0Jdf01/eZRL+nAoW0rDVS3H+Xdn0hRHqBYAg+CTD3Hw1Xtjd7lnPJwPhfFGLetYAYJm9LNa6uZoDh5tIYybTnYqNgp0Os7HFUiy5Mj6mIA5PeK3EwG2mrnsqJAmDli82pJAvdZ9XcUhpZ+66DpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/t0bJ4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/t0bJ4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F401F000E9;
	Mon, 27 Jul 2026 12:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154572;
	bh=uV7Kh0keWGtMQgsG+PNorS/B1ycaHiShJ+Qvn6az7HY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h/t0bJ4q+RWA8hafxboB57DSMMMVfgtE+SmnfGc7wPR/I6rmCjFremvRtG1pVaBVN
	 RnBLabvFtnLQltZhFwm+FBs92aHMunRCK+rHkoZuR2AnTr/CgVvOJxCgBEI9d+efo1
	 wS1jn6U5hAtmcy9fQcS45r6bzzuH8qKIrIBJqUXfEfeunEO3zROfrCMYf8EvTamxjq
	 oAdeha40Vd+GJ99cpCGtjojwZRnflMoHBTepbS1RnXCbneZphKz6KOY4PDL8Zl+jEI
	 3WjkEoWXeSARug/DV9nhlMtzZSXkE5j48ZESfE3Ql2cxwKMwkvI806nI1amQvHVeaN
	 nxg5lvav2+m5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] ACPI: amba: drop unused assignment of
 acpi_device_id::driver_data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-5-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-5-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:16:12 +0000
Message-Id: <20260727121612.98F401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> This module sets the acpi_device_id::driver_data to 0 but
> the field is not actually used within the module, we can
> just drop it from the table.
>=20
> While we are at it - used a named initializer for the
> acpi_device_id::id field to increase readability and
> drop explicitly setting the list terminator fields.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D5

