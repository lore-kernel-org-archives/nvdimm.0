Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692685;
	b=nDIXIh9W90/cuMzZeHtMtKETsi/ugZW4qFl9LB/HW12vvit8d3JkacGyXqpfAWI4spSd
	 DHIbN51HKoEB3CuZNrgx2sLbkcNsJ/x/+OMRAp51xGWMwsiqeBLKUnEhU+BexgFwdi2q8
	 AxSUPF3W5ZGDxilZsxloXG7TZ4ysSpEFHc7Y7ShnDZoYxbPu4UXMJYUMEHFFEzR+d7Z49
	 Gf3QcIYk9Iya9cfaLLxs+5CkAsr5VkSwnYSY3oHjzadRwSCEOD1toVoowq/oDCMnl/pkA
	 3HlY1Wae9FvLTFlw5/kkr06Ie3e0QIwpYEVGhOse9frRlix4XTvuRr+lqV7YKsmmCeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692685;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VFgWVgLfe7OQeHc3CR1C8glp/R4J3/wE95dB+Ij2ZAc=;
	b=LRxQLEYhRLoz0ZaUbe5HhhhoC3WTeVmFF3XfG/dIgABaUp2FVxDHZ1uUNmxOctwo+ClV
	 +fhwm1AETXIoevfITCTfdPJPubPWpk4HsTzGGRysDH780oo3juEec9AvGnITRhuyJOudN
	 mNfijGrVcxgqEQ6517w+nlhbpf7MfeUZbpo87Ylf+8Fs0F1+3+T3D2JIaNZJ+cCqGGMdj
	 38NiLCT6qq5T6Anmufqx+WLWIokAgYSdi6Gm6/pXbGr2rrvszy6gtB2rkOSw9fyl4Q54Z
	 xV3AqlnliqecAJQCsTNVYyTziyqx+HoRComyW1xI6No9fwchiPqXSL2RocpU/3lEHgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZdNG0Qo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED8C606A324
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZdNG0Qo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096D71F01825;
	Thu, 22 Oct 2026 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792692684;
	bh=VFgWVgLfe7OQeHc3CR1C8glp/R4J3/wE95dB+Ij2ZAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OZdNG0Qo4UE3rRN/7HUpzE5O1MrPxMIZXwfae4t+cP20oYdkNfSBi4C9HtR8DdunM
	 NlncAXufU6v5edZBbnLNHoSDiqBMR/VdwBII3PKHejsiMb+svgEn2VEcG6f5DeMFSW
	 VaY8Jfd8OFCNJF2fri3Edz98SH2s46xeZSKuflzxQU8NZAvHb0YeEDeVuZwep5oU62
	 1QwwD/YnvSms43Ec7XTyEjPXwoUUzv6NmoPH0rLofYmY0uHScUnAcgrd0nL2iKNc4V
	 GbHzoVdFTgPcDQcaVru9iROeUyLBBcTxFP9Bf5DpLNDGYyckK5TsILL2sEREa7X66b
	 YoCz56qNZ5YbA==
Message-ID: <sashiko-outbox-181904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: test fork of a device DAX PUD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Alistair
 Popple" <apopple@nvidia.com>, "Dan Williams" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
 <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 18:11:23 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/mm: sysfs_ul() and rss_file_kb() duplicate vm_util.h h=
elpers
--

commit d02ba4b69f400c48de47f25c78208f1cfd2fe974
Author: Konstantin Khorenko <khorenko@virtuozzo.com>

selftests/mm: test fork of a device DAX PUD

This commit adds the fork_dax_pud selftest to verify that fork() properly
accounts a copied device DAX PUD mapping in the child's RssFile when page
tables are copied due to a guard region in the VMA.

> diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/se=
lftests/mm/fork_dax_pud.c
> new file mode 100644
> index 0000000000000..1fcf46341ace2
> --- /dev/null
> +++ b/tools/testing/selftests/mm/fork_dax_pud.c
[ ... ]
> +#include "kselftest.h"
> +#include "vm_util.h"
> +
> +#define SZ_1G		(1UL << 30)
> +#define DAX_SYSFS	"/sys/bus/dax/devices"
> +
> +static sigjmp_buf sigbus_jmp;
> +
> +static void sigbus_handler(int sig)
> +{
> +	siglongjmp(sigbus_jmp, 1);
> +}
> +
> +static unsigned long sysfs_ul(const char *dev, const char *attr)
> +{
> +	char path[PATH_MAX], buf[64];
> +	unsigned long val =3D 0;
> +	FILE *f;
> +
> +	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
> +	f =3D fopen(path, "r");
> +	if (!f)
> +		return 0;
> +	if (fgets(buf, sizeof(buf), f))
> +		val =3D strtoul(buf, NULL, 0);
> +	fclose(f);
> +	return val;
> +}
> +
> +static bool dax_dev_ok(const char *path)
> +{
> +	const char *name =3D strrchr(path, '/');
> +
> +	name =3D name ? name + 1 : path;
> +	return sysfs_ul(name, "align") =3D=3D SZ_1G &&
> +	       sysfs_ul(name, "size") >=3D 2 * SZ_1G;
> +}
> +
> +static long rss_file_kb(void)
> +{
> +	char line[256];
> +	long kb =3D -1;
> +	FILE *f =3D fopen("/proc/self/status", "r");
> +
> +	if (!f)
> +		return -1;
> +	while (fgets(line, sizeof(line), f))
> +		if (sscanf(line, "RssFile: %ld", &kb) =3D=3D 1)
> +			break;
> +	fclose(f);
> +	return kb;
> +}

[Severity: Medium]
fork_dax_pud.c includes vm_util.h and links against vm_util.c, which already
provide shared helpers for reading sysfs attributes and parsing
/proc/self/status:

tools/testing/selftests/mm/vm_util.h:
bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len=
);
uint64_t read_pmd_pagesize(void);
unsigned long rss_anon(void);
...
int write_sysfs(const char *file_path, unsigned long val);
int read_sysfs(const char *file_path, unsigned long *val);

In main() -> dax_dev_ok() -> sysfs_ul(), the test hand-rolls sysfs unsigned
long reading with fopen(), fgets(), strtoul(), and fclose() to read the
device align and size attributes under /sys/bus/dax/devices/<dev>/.

Similarly, in the child path of main() -> rss_file_kb(), the test manually
scans /proc/self/status for RssFile using fopen(), fgets(), and sscanf().

Could sysfs_ul() use read_sysfs() (or read_file()), and could rss_file_kb()
use check_for_pattern() or be added alongside rss_anon() in vm_util.c inste=
ad
of reimplementing these helpers locally?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-vstor-1501=
43-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com?part=3D2
