Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907019;
	b=M9G1msIM83aXc8/rvZ6Fmva6OKWLKTGMKRCqq7sRYaMUx6/HQs2JiXm7tJSuXjh41xSD
	 s2MQDBGA1IquJDvuJmIzSjin/Nz59KjcLEZpINY1VgPmNMbLwS6r2mc31kQLYhd0v1Yam
	 Y28rSqmjvd8++QhMPLh3WUvZkc0tGYgKRV8VDOuczn0wWWyrVwBZfbO/cE7AN7PbeCygh
	 TieOVsD91oYmMFhR080glxGn3g7gqD2KU9k9rDIvcSd0UtNfAPkZqfK/NBUPNw71YVv4Y
	 a+Germfc9N4ZdncW7x+6x4UpM1eXKPfWuscn4eUC4+QyiuTh1hrBM88jnQ5VwGZCcjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907019;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=FAsJXkYVAQSUgwDhMmwhMtDkQP3tUi7fcr4VrLnOjXc=;
	b=RmxJz7tmVPpkr8wveZGRrIF9l5DnJfrNxeCEoikxgrjtsGAhaDjBodnXqXNlFeMshpKV
	 TileY99eYQeAbYGhES0IM5coErdYD1IUHDe2PGVba81AKtl0Y3ccZCCtUqRnATI35UI79
	 c9UQYXGvyLAAM49dFr2J/inufXRPUedZ+AEQqem8Pam0NGzambp1Kp/lQXKTOO+GzovNS
	 vJfdC9vZRVcGyECu+cskGc2Dzizk5vmRQXDCnlCuYZBzmd/gJ5mxFJj1CpmR4Jbb85ZRa
	 1V/VOsxO/dOH/jw2h22ePTpjN1KM17P+UqOthBH7a4DKP/GNtCTHOvy+NhCfx+g1lnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHDZLmw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85005606A6F7;
	Thu,  5 Nov 2026 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHDZLmw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD64A1F00A18;
	Thu,  5 Nov 2026 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907019;
	bh=FAsJXkYVAQSUgwDhMmwhMtDkQP3tUi7fcr4VrLnOjXc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RHDZLmw+jRlBL4BiICTB9qLaz0FvLxc9gq9ngSTUFKw//Hg7znEMuYqMx2ZvPKW09
	 hcm8fRqobYw+GIBb1JAF/2g3psGymnPCUMV59Oh5r/Xws5xXNLlRWTkvx9R8CPE3fS
	 UP5+GFU/CAy8333PITAOCg4j+FxT2lrtu//8hPbgBP0J95nhoTkTQ6bfOFs5pQWYCN
	 hnRdVALc7lAC5Vbc5wiAbkRXVplbN4XHBB5y8uZI5f5lHOvICL6dX6Fs1eessV73EB
	 QdruZpfSvEv5OGIdDNIEB/jsnOCM8+VmxncO+hdzK7aCVORt/E0jpg76c/AZCnm0Ym
	 6I12mpCJnM2aQ==
Message-ID: <eb5e8a1c-a654-4d68-92b1-db0128fa8752@kernel.org>
Date: Thu, 5 Nov 2026 20:30:14 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: test fork of a device DAX PUD
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/26 18:00, Konstantin Khorenko wrote:
> Fork a process that maps a device DAX instance with a PUD, in a VMA
> whose page tables fork copies because it has a guard region. The child
> must account the copied PUD in its RssFile, which a new rss_file() in
> vm_util reads as rss_anon() reads RssAnon.
> 
> Without a reference, an rmap and a counter for the copied PUD, the
> child's RssFile misses the PUD, and its exit leaves the child's file
> counter negative: "Bad rss-counter state".
> 
> It runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE: on
> a kernel without the fix it leaves the device folio's mapcount below
> zero.
> 
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  MAINTAINERS                               |   1 +
>  tools/testing/selftests/mm/Makefile       |   1 +
>  tools/testing/selftests/mm/fork_dax_pud.c | 114 ++++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh |   1 +
>  tools/testing/selftests/mm/vm_util.c      |  21 ++++++
>  tools/testing/selftests/mm/vm_util.h      |   1 +
>  6 files changed, 139 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d63d8b2152773..247e16f3276f4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17931,6 +17931,7 @@ F:	mm/huge_memory.c
>  F:	mm/khugepaged.c
>  F:	mm/mm_slot.h
>  F:	tools/mm/thpmaps
> +F:	tools/testing/selftests/mm/fork_dax_pud.c
>  F:	tools/testing/selftests/mm/khugepaged.c
>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>  F:	tools/testing/selftests/mm/transhuge-stress.c
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 0ea72e9979347..130500f5f6e0a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -108,6 +108,7 @@ TEST_GEN_FILES += folio_split_race_test
>  TEST_GEN_FILES += folio_order_check
>  TEST_GEN_FILES += khugepaged_sync_check
>  TEST_GEN_FILES += khugepaged_race
> +TEST_GEN_FILES += fork_dax_pud
>  TEST_GEN_FILES += soft-dirty
>  
>  ifeq ($(ARCH),x86_64)
> diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/selftests/mm/fork_dax_pud.c
> new file mode 100644
> index 0000000000000..0d19c30b1dc6f
> --- /dev/null
> +++ b/tools/testing/selftests/mm/fork_dax_pud.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * fork() of a process that maps a device DAX instance with a PUD, in a VMA
> + * whose page tables fork copies because it has a guard region. The child
> + * must account the copied PUD in its RssFile.
> + *
> + * Runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE that
> + * nothing else maps, with 1 GiB alignment and at least 2 GiB. To make one
> + * on pmem emulated in RAM, with CONFIG_X86_PMEM_LEGACY and
> + * CONFIG_DEV_DAX_PMEM:
> + *
> + *	boot with memmap=3G!4G
> + *	ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
> + *	FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud
> + */
> +#define _GNU_SOURCE
> +#include <asm-generic/mman.h> /* Force the import of the tools version. */
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <setjmp.h>
> +#include <signal.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/wait.h>
> +
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
> +static bool dax_attr(const char *dev, const char *attr, unsigned long *val)
> +{
> +	char path[PATH_MAX];
> +
> +	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
> +	return !read_sysfs(path, val);
> +}
> +
> +static bool dax_dev_ok(const char *path)
> +{
> +	const char *name = strrchr(path, '/');
> +	unsigned long align, size;
> +
> +	name = name ? name + 1 : path;
> +	return dax_attr(name, "align", &align) && align == SZ_1G &&
> +	       dax_attr(name, "size", &size) && size >= 2 * SZ_1G;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	const char *path = argc > 1 ? argv[1] : getenv("FORK_DAX_PUD_DEVICE");
> +	char *area, *mem;
> +	int fd, status;
> +	pid_t pid;
> +
> +	ksft_print_header();
> +	if (!path)
> +		ksft_exit_skip("no devdax device given\n");
> +	if (!dax_dev_ok(path))
> +		ksft_exit_skip("%s: needs 1 GiB alignment and 2 GiB\n", path);
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		ksft_exit_skip("%s: %s\n", path, strerror(errno));
> +	area = mmap(NULL, 3 * SZ_1G, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (area == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	mem = (char *)(((unsigned long)area + SZ_1G - 1) & ~(SZ_1G - 1));
> +	mem = mmap(mem, 2 * SZ_1G, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);
> +	if (mem == MAP_FAILED)
> +		ksft_exit_skip("mmap %s: %s\n", path, strerror(errno));
> +
> +	/* A PUD in the first GiB, a guard page at the end of the second. */
> +	signal(SIGBUS, sigbus_handler);
> +	if (sigsetjmp(sigbus_jmp, 1))
> +		ksft_exit_skip("%s cannot be mapped with a PUD\n", path);
> +	FORCE_READ(mem[0]);
> +	signal(SIGBUS, SIG_DFL);
> +	if (madvise(mem + 2 * SZ_1G - getpagesize(), getpagesize(),
> +		    MADV_GUARD_INSTALL))
> +		ksft_exit_skip("MADV_GUARD_INSTALL: %s\n", strerror(errno));
> +
> +	ksft_set_plan(1);
> +	fflush(stdout);
> +	pid = fork();
> +	if (pid < 0)
> +		ksft_exit_fail_perror("fork");
> +	if (!pid)
> +		_exit(rss_file() < (SZ_1G >> 10) ? 10 : 0);
> +	if (waitpid(pid, &status, 0) != pid)
> +		ksft_exit_fail_perror("waitpid");
> +
> +	if (!WIFEXITED(status) || WEXITSTATUS(status))
> +		ksft_test_result_fail("child does not account the copied PUD\n");
> +	else
> +		ksft_test_result_pass("devdax PUD copied by fork\n");
> +
> +	munmap(area, 3 * SZ_1G);
> +	close(fd);
> +	ksft_finished();
> +}

I prefer to not merge this. It requires an actual dax device, so it's not very
applicable on CI systems, and we don't want selftests to take parameters in one
form or the other.

-- 
Cheers,

David
