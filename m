From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: How can we better support vender specific _DSM commands in ndctl?
Date: Wed, 23 Jan 2019 22:47:44 +0000
Message-ID: <PU1P153MB0169D295CC946C507FBD1F34BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Lijun Pan <Lijun.Pan-8PEkshWhKlo@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Boylston, Brian" <brian.boylston-ZPxbGqLxI0U@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi all,
Hyper-V implements virtualized NVDIMM for guests running on it [1]. The
command set is documented on the RFIC_LIST page on uefi.org [2]. 

After Linux guest boots up, I can see these dev files:
/dev/ndctl0   /dev/nmem0   /dev/pmem0 
and I can create an xfs file system on /dev/pmem0, mount it and use it. 

Everything works just fine except for one thing: I can't call the Hyper-V 
specific _DSM methods. So I wrote a patch [3] to allow the methods to
be called (I Cc'd you when posting the patch. Please review it.).

And then I found it looks ndctl doesn't allow me to easily call *all* the
_DSM methods, and I can't easily use ndctl to interpret the output in a
way I prefer.

My understanding is that: it looks when the kernel nvdimm driver and ndctl
were originally implemented, the code was mainly for Intel NVDIMM. Later
people introduced the support for NVDIMM_FAMILY_{HPE1, HPE2, MSFT},
and introduced the kernel ND_CMD_CALL ioctl to allow ndctl to call 
vender-specific methods, but up to now, it looks the majority of the cmds
(if not all of the cmds) shown by "ndctl --list-cmds" are not very useful to
call vender specific methods, especially for NVDIMM_FAMILY_MSFT:

e.g.: for NVDIMM_FAMILY_MSFT, only Function 11 is used, and the
only useful info from "ndctl list --dimms --health" is:

  "health":{
    "health_state":"ok",
    "temperature_celsius":27.000000,
    "life_used_percentage":3
  }

And, in msft_cmd_smart_get_health(), we only count the number of error bits,
and we drop the detailed info about the errors, and we lose some info
from the struct ndn_msft_smart_data, e.g. err_thresh_stat, warn_thresh_stat,
count_dram_uncorr_err and count_dram_corr_err, which IMO could be useful.

(See "libndctl: add support for the MSFT family of DSM functions" [4])

And, NVDIMM_FAMILY_MSFT has 32 methods [5], but except Function 11, it
looks the other methods can not be mapped to the existing ndctl commands.


Now, the new NVDIMM type NVDIMM_FAMILY_HYPERV has 4 Hyper-V specific
_DSM methods [2]:

Get Health Information (Function Index 1)
Get Unsafe Shutdown Count (Function Index 2)
Inject Error (Function Index 3)
Query Injected Errors (Function Index 4)

For Function 1, I made a patch 
"libndctl: add support for the HYPER-V family of DSM functions" (please see [6],
especially hyperv_cmd_smart_get_health() in the patch) to use it, but the
existing ndctl interface, i.e. util_dimm_health_to_json(), only allows me to
return to the user a string of "fatal", "critical", "non-critical" or "ok", while 
I would like to return more details about the errors to the user.

Function 3 can not be mapped to ndctl/inject-smart.c: smart_inject(), because
it's incompatible with Intel NVDIMM.

Function 2 and 4 can't be mapped to the existing ndctl commands either.

I'm wondering how I should use the 4 Hyper-V specific methods in ndctl.

I appreciate your insights. Thank you!

--Dexuan

[1] https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/manage/persistent-memory-cmdlets
[2] http://www.uefi.org/RFIC_LIST, see the link to "Virtual NVDIMM 0x1901" on the page.
[3] https://www.lkml.org/lkml/2019/1/23/761
[4] https://github.com/pmem/ndctl/commit/2cf2acca0288389a39ac823a42a5e048575d52db
[5] https://docs.microsoft.com/en-us/windows-hardware/drivers/storage/-dsm-interface-for-byte-addressable-energy-backed-function-class--function-interface-1-
[6] https://github.com/dcui/ndctl/commit/12feb081c881b24fee9f6cf088037c2e30248252
