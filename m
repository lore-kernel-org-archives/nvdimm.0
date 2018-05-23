Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C260207E4E04
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:45:38 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] test: add a MADV_HWPOISON test
Date: Wed, 23 May 2018 17:45:36 +0000
Message-ID: <1527097534.9654.6.camel@intel.com>
References: <152700595813.1878.7740364417021385747.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152700595813.1878.7740364417021385747.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <CAB7F17B618C3544ACB74A551D149BFA@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-05-22 at 09:19 -0700, Dan Williams wrote:
> Check that injecting soft-poison to a dax mapping results in SIGBUS with
> the expected BUS_MCEERR_AR siginfo data.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/dax-pmd.c |  130
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 126 insertions(+), 4 deletions(-)

Looks good, applied.

> 
> diff --git a/test/dax-pmd.c b/test/dax-pmd.c
> index 65bee6ffe907..abff4f9fd199 100644
> --- a/test/dax-pmd.c
> +++ b/test/dax-pmd.c
> @@ -12,6 +12,7 @@
>   */
>  #include <stdio.h>
>  #include <unistd.h>
> +#include <setjmp.h>
>  #include <sys/mman.h>
>  #include <linux/mman.h>
>  #include <sys/types.h>
> @@ -192,15 +193,130 @@ int test_dax_directio(int dax_fd, unsigned long
> align, void *dax_addr, off_t off
>  	return rc;
>  }
>  
> +static sigjmp_buf sj_env;
> +static int sig_mcerr_ao, sig_mcerr_ar, sig_count;
> +
> +static void sigbus_hdl(int sig, siginfo_t *si, void *ptr)
> +{
> +	switch (si->si_code) {
> +	case BUS_MCEERR_AO:
> +		fprintf(stderr, "%s: BUS_MCEERR_AO addr: %p len: %d\n",
> +			__func__, si->si_addr, 1 << si->si_addr_lsb);
> +		sig_mcerr_ao++;
> +		break;
> +	case BUS_MCEERR_AR:
> +		fprintf(stderr, "%s: BUS_MCEERR_AR addr: %p len: %d\n",
> +			__func__, si->si_addr, 1 << si->si_addr_lsb);
> +		sig_mcerr_ar++;
> +		break;
> +	default:
> +		sig_count++;
> +		break;
> +	}
> +
> +	siglongjmp(sj_env, 1);
> +}
> +
> +static int test_dax_poison(int dax_fd, unsigned long align, void
> *dax_addr,
> +		off_t offset)
> +{
> +	unsigned char *addr = MAP_FAILED;
> +	struct sigaction act;
> +	unsigned x = x;
> +	void *buf;
> +	int rc;
> +
> +	if (posix_memalign(&buf, 4096, 4096) != 0)
> +		return -ENOMEM;
> +
> +	memset(&act, 0, sizeof(act));
> +	act.sa_sigaction = sigbus_hdl;
> +	act.sa_flags = SA_SIGINFO;
> +
> +	if (sigaction(SIGBUS, &act, 0)) {
> +		fail();
> +		rc = -errno;
> +		goto out;
> +	}
> +
> +	/* dirty the block on disk to bypass the default zero page */
> +	rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
> +	if (rc < 4096) {
> +		fail();
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +	fsync(dax_fd);
> +
> +	addr = mmap(dax_addr, 2*align, PROT_READ|PROT_WRITE,
> +			MAP_SHARED_VALIDATE|MAP_POPULATE|MAP_SYNC,
> dax_fd, offset);
> +	if (addr == MAP_FAILED) {
> +		fail();
> +		rc = -errno;
> +		goto out;
> +	}
> +
> +	if (sigsetjmp(sj_env, 1)) {
> +		if (sig_mcerr_ar) {
> +			fprintf(stderr, "madvise triggered 'action
> required' sigbus\n");
> +			goto clear_error;
> +		} else if (sig_count) {
> +			fail();
> +			return -ENXIO;
> +		}
> +	}
> +
> +	rc = madvise(addr + align / 2, 4096, MADV_HWPOISON);
> +	if (rc) {
> +		fail();
> +		rc = -errno;
> +		goto out;
> +	}
> +
> +	/* clear the error */
> +clear_error:
> +	if (!sig_mcerr_ar) {
> +		fail();
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	rc = fallocate(dax_fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
> +			offset + align / 2, 4096);
> +	if (rc) {
> +		fail();
> +		rc = -errno;
> +		goto out;
> +	}
> +
> +	rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
> +	if (rc < 4096) {
> +		fail();
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +	fsync(dax_fd);
> +
> +	/* check that we can fault in the poison page */
> +	x = *(volatile unsigned *) addr + align / 2;
> +	rc = 0;
> +
> +out:
> +	if (addr != MAP_FAILED)
> +		munmap(addr, 2 * align);
> +	free(buf);
> +	return rc;
> +}
> +
>  /* test_pmd assumes that fd references a pre-allocated + dax-capable
> file */
>  static int test_pmd(int fd)
>  {
> -	unsigned long long m_align, p_align;
> +	unsigned long long m_align, p_align, pmd_off;
>  	struct fiemap_extent *ext;
> +	void *base, *pmd_addr;
>  	struct fiemap *map;
>  	int rc = -ENXIO;
>  	unsigned long i;
> -	void *base;
>  
>  	if (fd < 0) {
>  		fail();
> @@ -249,9 +365,15 @@ static int test_pmd(int fd)
>  	m_align = ALIGN(base, HPAGE_SIZE) - ((unsigned long) base);
>  	p_align = ALIGN(ext->fe_physical, HPAGE_SIZE) - ext-
> >fe_physical;
>  
> -	rc = test_dax_directio(fd, HPAGE_SIZE, (char *) base + m_align,
> -			ext->fe_logical + p_align);
> +	pmd_addr = (char *) base + m_align;
> +	pmd_off =  ext->fe_logical + p_align;
> +	rc = test_dax_directio(fd, HPAGE_SIZE, pmd_addr, pmd_off);
> +	if (rc)
> +		goto err_directio;
> +
> +	rc = test_dax_poison(fd, HPAGE_SIZE, pmd_addr, pmd_off);
>  
> + err_directio:
>   err_extent:
>   err_mmap:
>  	free(map);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
