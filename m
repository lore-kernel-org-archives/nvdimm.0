Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B31DE8A8;
	Tue,  1 Jul 2025 14:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381226; cv=none; b=VobzVajHGVP2LLeLp5O07lHt5QtCzDgf8hGopzy+dbaAGV/A6wso0lmttBRoWiBxwvBgZwOd4jLl1ovzjJhghK8ZFcMklIEVqpn/ufj2MqTZwh5u4PswUOp0zPqendydAzyB+MIXtTejQ8QGjkjrlgQyexTWNKYudd+LkmzKhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381226; c=relaxed/simple;
	bh=OfFbLijbpxyN4dyHU3EIzh9SsoOjBXoGBr1nfJrccmE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZE8Rf0SSUbVEYqejrU9M1il95l9kRjZPDWkWvP/x7bOUGXvKabxlVjBeA5UmTPGcCiECmjTunEP7TH0S59pgDOhpdWPEqNdNdknrMpOhfHWgxJ3ujJUIVkmmQwKaB/4ZM4RWPY3sl6N8mILEwt4mtjY7lPRBLk/+mKJhfTjabA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bWm7f4XBdz6L5Gm;
	Tue,  1 Jul 2025 22:46:38 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D09D1402EA;
	Tue,  1 Jul 2025 22:47:01 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 1 Jul
 2025 16:47:00 +0200
Date: Tue, 1 Jul 2025 15:46:59 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
CC: <mpatocka@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
	<axboe@kernel.dk>, <hch@lst.de>, <dan.j.williams@intel.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v1 04/11] dm-pcache: add segment layer
Message-ID: <20250701154659.000067f9@huawei.com>
In-Reply-To: <20250624073359.2041340-5-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
	<20250624073359.2041340-5-dongsheng.yang@linux.dev>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 24 Jun 2025 07:33:51 +0000
Dongsheng Yang <dongsheng.yang@linux.dev> wrote:

> Introduce segment.{c,h}, an internal abstraction that encapsulates
> everything related to a single pcache *segment* (the fixed-size
> allocation unit stored on the cache-device).
>=20
> * On-disk metadata (`struct pcache_segment_info`)
>   - Embedded `struct pcache_meta_header` for CRC/sequence handling.
>   - `flags` field encodes a =E2=80=9Chas-next=E2=80=9D bit and a 4-bit *t=
ype* class
>     (`CACHE_DATA` added as the first type).
>=20
> * Initialisation
>   - `pcache_segment_init()` populates the in-memory
>     `struct pcache_segment` from a given segment id, data offset and
>     metadata pointer, computing the usable `data_size` and virtual
>     address within the DAX mapping.
>=20
> * IO helpers
>   - `segment_copy_to_bio()` / `segment_copy_from_bio()` move data
>     between pmem and a bio, using `_copy_mc_to_iter()` and
>     `_copy_from_iter_flushcache()` to tolerate hw memory errors and
>     ensure durability.
>   - `segment_pos_advance()` advances an internal offset while staying
>     inside the segment=E2=80=99s data area.
>=20
> These helpers allow upper layers (cache key management, write-back
> logic, GC, etc.) to treat a segment as a contiguous byte array without
> knowing about DAX mappings or persistence details.
>=20
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Hi

Just one trivial comment.

> diff --git a/drivers/md/dm-pcache/segment.h b/drivers/md/dm-pcache/segmen=
t.h
> new file mode 100644
> index 000000000000..9675951ffaf8
> --- /dev/null
> +++ b/drivers/md/dm-pcache/segment.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _PCACHE_SEGMENT_H
> +#define _PCACHE_SEGMENT_H
> +
> +#include <linux/bio.h>
> +
> +#include "pcache_internal.h"
> +
> +struct pcache_segment_info {
> +	struct pcache_meta_header	header;	/* Metadata header for the segment */

The comment is fairly obvious given the type of the field. I'd drop the com=
ment.

> +	__u32			flags;
> +	__u32			next_seg;
> +};


