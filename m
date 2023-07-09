Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C23522E
	for <nvdimm@lists.linux.dev>; Sun,  9 Jul 2023 11:51:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10765"; a="123951979"
X-IronPort-AV: E=Sophos;i="6.01,192,1684767600"; 
   d="scan'208";a="123951979"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2023 20:50:46 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9C955DA68D
	for <nvdimm@lists.linux.dev>; Sun,  9 Jul 2023 20:50:43 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id D3D61D4F44
	for <nvdimm@lists.linux.dev>; Sun,  9 Jul 2023 20:50:42 +0900 (JST)
Received: from [10.167.215.54] (unknown [10.167.215.54])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 4FC906BC48;
	Sun,  9 Jul 2023 20:50:42 +0900 (JST)
Message-ID: <697878b5-ecea-3172-695c-db9191548216@fujitsu.com>
Date: Sun, 9 Jul 2023 19:50:41 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [NDCTL PATCH] cxl/region: Always use the correct target position
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20230630151245.1318-1-yangx.jy@fujitsu.com>
From: Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <20230630151245.1318-1-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27740.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27740.007
X-TMASE-Result: 10--23.468000-10.000000
X-TMASE-MatchedRID: 6Yvl3or3fgqPvrMjLFD6eDo39wOA02LhG24YVeuZGmOZtziFUn+D+eAf
	SNitoKTvLluBF7lCexn0lZqQGuQv90zOmjZzSvazrmLeMrcoM6gL8TGleseLPMiCh8yBqE+tK7m
	JD0QzrgT4EXi5HZwxNmDe3UNYdGMnNp8NVhNwDC6/QNwZdfw3FVF5adRR2Ej1b3Wpj9NSXKy/BR
	68O365bn9eOltIlLtr8Pwm1A0EoTfmh3qTH3T2BM69emDs42ddfS0Ip2eEHny+qryzYw2E8LLn+
	0Vm71Lc+x/oWSsuvysLbigRnpKlKSBuGJWwgxAra7leoU/OMhPyMXSQdzxi9A==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hi all,

Kindly ping.

This patch can only fixes the case that 2 way interleave is enabled 
across 2 CXL host bridges and each host bridge has 1 CXL Root Port.
PS: In other word, this patch is wrong when 2 way interleave is enabled 
across 2 CXL host bridges and each host bridge has 2 CXL Root Ports.

I am trying to find a better solution. If you have any suggestion, 
please let me know.

Best Regards,
Xiao Yang

On 2023/6/30 23:12, Xiao Yang wrote:
> create_region() uses the wrong target position in some cases.
> For example, cxl create-region command fails to create a new
> region in 2 way interleave set when mem0 connects target1(position:1)
> and mem1 connects target0(position:0):
> 
> $ cxl list -M -P -D -T -u
> [
>    {
>      "ports":[
>        {
>          "port":"port1",
>          "host":"pci0000:16",
>          "depth":1,
>          "nr_dports":1,
>          "dports":[
>            {
>              "dport":"0000:16:00.0",
>              "id":"0"
>            }
>          ],
>          "memdevs:port1":[
>            {
>              "memdev":"mem0",
>              "ram_size":"512.00 MiB (536.87 MB)",
>              "serial":"0",
>              "host":"0000:17:00.0"
>            }
>          ]
>        },
>        {
>          "port":"port2",
>          "host":"pci0000:0c",
>          "depth":1,
>          "nr_dports":1,
>          "dports":[
>            {
>              "dport":"0000:0c:00.0",
>              "id":"0"
>            }
>          ],
>          "memdevs:port2":[
>            {
>              "memdev":"mem1",
>              "ram_size":"512.00 MiB (536.87 MB)",
>              "serial":"0",
>              "host":"0000:0d:00.0"
>            }
>          ]
>        }
>      ]
>    },
>    {
>      "root decoders":[
>        {
>          "decoder":"decoder0.0",
>          "resource":"0x750000000",
>          "size":"4.00 GiB (4.29 GB)",
>          "interleave_ways":2,
>          "interleave_granularity":8192,
>          "max_available_extent":"4.00 GiB (4.29 GB)",
>          "pmem_capable":true,
>          "volatile_capable":true,
>          "accelmem_capable":true,
>          "nr_targets":2,
>          "targets":[
>            {
>              "target":"pci0000:16",
>              "alias":"ACPI0016:00",
>              "position":1,
>              "id":"0x16"
>            },
>            {
>              "target":"pci0000:0c",
>              "alias":"ACPI0016:01",
>              "position":0,
>              "id":"0xc"
>            }
>          ]
>        }
>      ]
>    }
> ]
> 
> $ cxl create-region -t ram -d decoder0.0 -m mem0 mem1
> cxl region: create_region: region0: failed to set target0 to mem0
> cxl region: cmd_create_region: created 0 regions
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>   cxl/region.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 07ce4a3..946b5ff 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -667,6 +667,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>   		struct json_object *jobj =
>   			json_object_array_get_idx(p->memdevs, i);
>   		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> +		struct cxl_target *target = cxl_decoder_get_target_by_memdev(p->root_decoder,
> +										memdev);
>   
>   		ep_decoder = cxl_memdev_find_decoder(memdev);
>   		if (!ep_decoder) {
> @@ -683,7 +685,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>   			try(cxl_decoder, set_mode, ep_decoder, p->mode);
>   		}
>   		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
> -		rc = cxl_region_set_target(region, i, ep_decoder);
> +		rc = cxl_region_set_target(region, cxl_target_get_position(target), ep_decoder);
>   		if (rc) {
>   			log_err(&rl, "%s: failed to set target%d to %s\n",
>   				devname, i, cxl_memdev_get_devname(memdev));
