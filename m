Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213DBE55E
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 15:14:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="122783361"
X-IronPort-AV: E=Sophos;i="6.01,171,1684767600"; 
   d="scan'208";a="122783361"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 00:12:56 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9D4CDD3EB4
	for <nvdimm@lists.linux.dev>; Sat,  1 Jul 2023 00:12:53 +0900 (JST)
Received: from aks-ab1.gw.nic.fujitsu.com (aks-ab1.gw.nic.fujitsu.com [192.51.207.11])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id C50D8D3F3D
	for <nvdimm@lists.linux.dev>; Sat,  1 Jul 2023 00:12:52 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.215.54])
	by aks-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8C8782FC85C5;
	Sat,  1 Jul 2023 00:12:51 +0900 (JST)
From: Xiao Yang <yangx.jy@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: [NDCTL PATCH] cxl/region: Always use the correct target position
Date: Fri, 30 Jun 2023 23:12:45 +0800
Message-Id: <20230630151245.1318-1-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27724.000
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27724.000
X-TMASE-Result: 10--15.488200-10.000000
X-TMASE-MatchedRID: 8CDFLipM1pHkht9v6t8rY/CCu8kVj0TRKQNhMboqZlr+Aw16GgqpOzdM
	oT0/Z54OvEI4haRugcS6lzKFP+BpwpR1QS4wQ645oHDoEp2TszHBOVz0Jwcxl6vCrG0TnfVUilv
	Ab18i4hO0/C1zMWsJtEV+JJ1FckPslwV2iaAfSWcURSScn+QSXt0H8LFZNFG7bkV4e2xSge7dun
	A1VdPDv6ZV3g68QQ+eje/Glscw6hcwEZGFDer3lOulxyHOcPoH
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

create_region() uses the wrong target position in some cases.
For example, cxl create-region command fails to create a new
region in 2 way interleave set when mem0 connects target1(position:1)
and mem1 connects target0(position:0):

$ cxl list -M -P -D -T -u
[
  {
    "ports":[
      {
        "port":"port1",
        "host":"pci0000:16",
        "depth":1,
        "nr_dports":1,
        "dports":[
          {
            "dport":"0000:16:00.0",
            "id":"0"
          }
        ],
        "memdevs:port1":[
          {
            "memdev":"mem0",
            "ram_size":"512.00 MiB (536.87 MB)",
            "serial":"0",
            "host":"0000:17:00.0"
          }
        ]
      },
      {
        "port":"port2",
        "host":"pci0000:0c",
        "depth":1,
        "nr_dports":1,
        "dports":[
          {
            "dport":"0000:0c:00.0",
            "id":"0"
          }
        ],
        "memdevs:port2":[
          {
            "memdev":"mem1",
            "ram_size":"512.00 MiB (536.87 MB)",
            "serial":"0",
            "host":"0000:0d:00.0"
          }
        ]
      }
    ]
  },
  {
    "root decoders":[
      {
        "decoder":"decoder0.0",
        "resource":"0x750000000",
        "size":"4.00 GiB (4.29 GB)",
        "interleave_ways":2,
        "interleave_granularity":8192,
        "max_available_extent":"4.00 GiB (4.29 GB)",
        "pmem_capable":true,
        "volatile_capable":true,
        "accelmem_capable":true,
        "nr_targets":2,
        "targets":[
          {
            "target":"pci0000:16",
            "alias":"ACPI0016:00",
            "position":1,
            "id":"0x16"
          },
          {
            "target":"pci0000:0c",
            "alias":"ACPI0016:01",
            "position":0,
            "id":"0xc"
          }
        ]
      }
    ]
  }
]

$ cxl create-region -t ram -d decoder0.0 -m mem0 mem1
cxl region: create_region: region0: failed to set target0 to mem0
cxl region: cmd_create_region: created 0 regions

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 cxl/region.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index 07ce4a3..946b5ff 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -667,6 +667,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		struct json_object *jobj =
 			json_object_array_get_idx(p->memdevs, i);
 		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+		struct cxl_target *target = cxl_decoder_get_target_by_memdev(p->root_decoder,
+										memdev);
 
 		ep_decoder = cxl_memdev_find_decoder(memdev);
 		if (!ep_decoder) {
@@ -683,7 +685,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 			try(cxl_decoder, set_mode, ep_decoder, p->mode);
 		}
 		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
-		rc = cxl_region_set_target(region, i, ep_decoder);
+		rc = cxl_region_set_target(region, cxl_target_get_position(target), ep_decoder);
 		if (rc) {
 			log_err(&rl, "%s: failed to set target%d to %s\n",
 				devname, i, cxl_memdev_get_devname(memdev));
-- 
2.39.2

