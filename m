Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22232339705;
	Mon, 27 Jul 2026 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154475; cv=none; b=Ke3sJ5perYCvJcbQn5YgGXZUC2LLmIXBN7dvDXl1cqbeaQSBFvErnvUfYyiOCLkPjkO7MLmcR49lHlw4clVdWrAEm8OCtbX18G4uvgeEE4yBWFnTEwqzyWYpd1/B25Yy43shVmcOXtQkKqazhmAN1BW9i9aQvnVjiy7YhdpCpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154475; c=relaxed/simple;
	bh=laauG2qGRghlUu8JOYj1DbbQ/763/MRwfVsSqXEziEg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WKxoc0QX23ZEnV/Papcp4L30wImUtpB/fv/jOQ/5sHjmZVBvLwxAh70XLfRs9BtILuH1+hLQQ26pbY9Er6zwYXm9ZAdFb60yJGExB7LVntanhBWjDCSDb6dxRc3kQJre0AN0lidNdk8HreOGo5RU616MOU/s4OFRFgIRNV0JMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5uq1qyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5uq1qyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0DB1F00A3E;
	Mon, 27 Jul 2026 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154473;
	bh=laauG2qGRghlUu8JOYj1DbbQ/763/MRwfVsSqXEziEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V5uq1qyq+VH34pndMpmBbRfhDvn7rRENkszoxBh5TY8AfoX8xQULBMTDa1rw9u0Gs
	 syg13N9eLpfqjoBB7xGiAQWLSlg0WbXXK7/d9j4gZobHZe/E8HNJjEdq4QJVUR09AL
	 9tPfX8wIYfFUkjbVIPVAnbF7Ajet8FECPqqjNgBdN7UEHBTJYPKCRTv7Tt7h9IxV+N
	 RBFcGNp+mym7Yp55/7quJ5OjcpWQ9fxME1M7f9PaVtaDgO6foZm/DQZE50SnIhKEP3
	 kJxMFbumpu7f26DOkncbolwOQGaeNzdO6vp9/wshdt73unIPPdVpZk9fP1saazw41w
	 DqH133kLXK0CQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] ACPI: ghes-nvidia: use a named initializer for
 acpi_device_id::id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-4-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-4-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:14:33 +0000
Message-Id: <20260727121433.8C0DB1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Use a named initializer for the acpi_device_id::id field for
> readability.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D4

