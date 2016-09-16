Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on071e.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::71e])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB95F1A1F09
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 18:18:17 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] ndctl: move test/dax-errors buffer to global to avoid gcc
 optimization
Date: Fri, 16 Sep 2016 01:18:16 +0000
Message-ID: <DF4PR84MB016998D3A84119EB743C41F9ABF30@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <147397849629.229288.3348330822830988783.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <147397849629.229288.3348330822830988783.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: Dave Jiang <dave.jiang@intel.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Dave Jiang
> Sent: Thursday, September 15, 2016 5:28 PM
> To: vishal.l.verma@intel.com
> Cc: linux-nvdimm@lists.01.org
> Subject: [PATCH] ndctl: move test/dax-errors buffer to global to
> avoid gcc optimization
> 
> Some gcc toolchain are optimizing out the memcpy and this causes dax-
> errors
> to not trigger the SIG_BUS when doing memcpy on an mmap'd buffer. By
> moving
> the buffer to a global variable this bypasses the optimization and
> allow
> the test to work as intended.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/dax-errors.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/test/dax-errors.c b/test/dax-errors.c
> index 11d0031..9ea5c91 100644
> --- a/test/dax-errors.c
> +++ b/test/dax-errors.c
> @@ -17,6 +17,8 @@
> 
>  static sigjmp_buf sj_env;
>  static int sig_count;
> +/* buf is global in order to avoid gcc memcpy optimization */
> +static void *buf;
> 
>  static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
>  {
> @@ -27,7 +29,7 @@ static void sigbus_hdl(int sig, siginfo_t *siginfo,
> void *ptr)
> 
>  static int test_dax_read_err(int fd)
>  {
> -	void *base, *buf;
> +	void *base;
>  	int rc = 0;
> 
>  	if (fd < 0) {
> 

I've run into that kind of problem before, and found that
marking *buf as volatile (and leaving it inside the function)
tends to be honored better by aggressive optimizing compilers
and linkers.

---
Robert Elliott, HPE Persistent Memory



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
