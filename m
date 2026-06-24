Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1EE3BED75;
	Wed, 24 Jun 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313791; cv=none; b=kItz+bYOKr8XbtxXfQzAhM95gaGJmnyAcPxZkXQjlrX7dKjs7B6o7+MlJMu5iEZEi7sfqkS92xNeBYNBI+7/YE853xg0GR20w8tlXD+QO99+65l4dVfVjEuTL7/CfdiAJTZsk5vGqG0hwL8RvttCT2TD5ERf3BrgvPQ0mgXVMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313791; c=relaxed/simple;
	bh=0WScFHkiuUF1EwQN2UwaqtzS+je2Wt/BeEF5wA2GUXA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nRYC1Ot1UgXfmIwVgbaWSYWrMUABp8NePK/SJgwl+vQjAhKHOfyXAtF6xp2QI1PV3KzQCU80tfh7yGB2QAXkXd+NVziRIsqNoTA1Q7oBJQKrIfBWWQB2gXoOdra4VUMWxSBcxVZWvnKdDRwBOrZwRbRhTZ48te5ErSkULoV7hkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRpriO7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cRpriO7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240EF1F00A3D;
	Wed, 24 Jun 2026 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313789;
	bh=0WScFHkiuUF1EwQN2UwaqtzS+je2Wt/BeEF5wA2GUXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cRpriO7kN4exQ8S4vujzpAe78OAGRohY3M9oK90aWgf0YWvGK/VjGeL8QKBKjAVNe
	 VORwXaUcTrkH4k5W4Z2Wg77ma8KXKi6UqwKDWc4O1k+WMhjP5pbehbI4KcJUSnyt5p
	 i0nFQ+soYX4KREY53AxWn0AvvHyoI1Hg0TITI4ShsNlqiVgWp4VeZTLXiLQgT1jB9O
	 f7UaDc+clzKMK7s9xAEMYCSasjX1bVFgBd53xJohobvR2Kah7x7Aj6Yb3GLgCJ3hyl
	 fleOi57DkfxL9f+Bq5nMICAbCHO8iZu78x7fDM7+bDGEdV1GoVuBlt7E3KMPqow8Iu
	 7yRZKGsOOJIRw==
From: sashiko-bot@kernel.org
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Richard Cheng" <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624150158.55264-1-icheng@nvidia.com>
References: <20260624150158.55264-1-icheng@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:09:48 +0000
Message-Id: <20260624150949.240EF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Patch submitted to the wrong repository: adds `ndctl` userspace tes=
t files to the kernel tree.
--

commit a640ffeb53f9a730f09dcd04ab6a813beaced234
Author: Richard Cheng <icheng@nvidia.com>

test/cxl-mbox: Regression test for huge CXL_MEM_SEND_COMMAND out.size

This patch introduces a regression test for an unbounded kvzalloc() in
cxl_mbox_cmd_ctor(). It creates a raw struct cxl_send_command and issues
the ioctl directly against the cxl_test mock memdev.

Link: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/

> diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> new file mode 100644
> index 0000000000000..d81327ba17df4
> --- /dev/null
> +++ b/test/cxl-mbox.c
> @@ -0,0 +1,129 @@
[ ... ]
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>

[Severity: Low]
Was this patch intended for the ndctl repository instead of the Linux
kernel tree? This includes an ndctl userspace library header that does
not exist in the kernel tree.

> +#include <cxl/cxl_mem.h>
> +
> +static const char provider[] =3D "cxl_test";

[ ... ]

> diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> new file mode 100755
> index 0000000000000..67fecf5a3f46f
> --- /dev/null
> +++ b/test/cxl-mbox.sh
> @@ -0,0 +1,48 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +
> +. $(dirname "$0")/common

[Severity: Low]
Does this code rely on an ndctl test dependency script that is absent from
the kernel tree? It looks like both this script and the C file above are
userspace tests belonging to the ndctl project rather than the kernel.

> +
> +BIN=3D"$TEST_PATH"/cxl-mbox
> +rc=3D77

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624150158.5526=
4-1-icheng@nvidia.com?part=3D1
