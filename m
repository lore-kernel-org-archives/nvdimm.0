From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v6] x86: fix kaslr and memmap collision
Date: Wed, 11 Jan 2017 13:00:24 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1701111246400.3579@nanos>
References: <148407086864.34638.4228724339196415751.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <148407086864.34638.4228724339196415751.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, 10 Jan 2017, Dave Jiang wrote:
> +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
> +long simple_strtol(const char *cp, char **endp, unsigned int base);

What are those functions for? They are not used in that patch at all.

> +static void mem_avoid_memmap(void)
> +{
> +	char arg[128];
> +	int rc = 0;

What's the point of defining this variable here and zero initializing it?

> +	/* see if we have any memmap areas */

Sentences start with an upper case letter. Everywhere!

> +	if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {

You can spare an indentation level by just returning when the search fails.

> +		int i = 0;
> +		char *str = arg;
> +
> +		while (str && (i < MAX_MEMMAP_REGIONS)) {

	for (i = 0; str && (i < MAX_MEMMAP_REGIONS); i++) {

Please.

> +			unsigned long long start, size;
> +			char *k = strchr(str, ',');
> +
> +			if (k)
> +				*k++ = 0;
> +
> +			rc = parse_memmap(str, &start, &size);
> +			if (rc < 0)
> +				break;
> +			str = k;
> +			/* a usable region that should not be skipped */
> +			if (size == 0)
> +				continue;
> +
> +			mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].start = start;
> +			mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].size = size;

So this makes no sense. You parse start/size as unsigned long long and
then store it in an unsigned long. Works on 64bit, but on 32bit this is
just wrong:

Assume a memmap above 4G, which then will create a avoid region below 4G
due to truncation to unsigned long.

Thanks,

	tglx
