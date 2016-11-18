From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Add warning when memmap=nn!ss and
 CONFIG_RANDOMIZE_BASE enabled
Date: Fri, 18 Nov 2016 09:47:01 -0700
Message-ID: <c3dc208d-c604-0a45-13a4-2aa0e92a7ac7@intel.com>
References: <147941499514.131046.6450643991764692220.stgit@djiang5-desk3.ch.intel.com>
 <alpine.DEB.2.20.1611181224440.3615@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1611181224440.3615@nanos>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



On 11/18/2016 04:33 AM, Thomas Gleixner wrote:
> On Thu, 17 Nov 2016, Dave Jiang wrote:
>> CONFIG_RANDOMIZE_BASE can place the kernel anywhere. This causes
>> a problem for when memmap=nn!ss is used. This information is not
>> known until after the kernel starts executing and the decision
>> for where the randomized base goes happens before the kernel is
>> uncompressed. memmap=nn!ss is not reliable in the presence of
>> CONFIG_RANDOMIZE_BASE.
> 
> So this is a description of a problem. Now what's missing is a
> useful explanation why you think that adding a warning will make
> things better.
> 
> IMNSHO adding that warning is just a pointless exercise.
> 
> Why aren't you addressing the real issue and make the boot code
> parse that option and prevent that region from being used for
> kernel placement?
> 
> The same issue exists for other memmap options as well, not just
> for that PMEM thingy.
> 
> Thanks,
> 
> tglx
> 

I wasn't planning to fix it because the pmem memmap option is really
only used for testing. Is it possible to parse the kernel commandline
parameters before the kernel is uncompressed?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlgvMIUACgkQZBXE8WajuT5aoAEAmXEJ0git9CwD4RhXV3+A/bmF
CN1iLKoXHOvcpQ0FcDsA/j8UKmobWBHyswb6RCSu2uSqTt6XreMG7uNamT1eMt0J
=hk/4
-----END PGP SIGNATURE-----
