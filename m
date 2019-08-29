Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D80692021B6F9
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 17:19:40 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/3] greedy namespace creation
Date: Wed, 28 Aug 2019 18:17:32 -0600
Message-Id: <20190829001735.30289-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Steve Scargall <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Patch 1 and 2 refactor and clarify the documentation for the way
filtering works using --bus=, --region=, and --dimm= options for all
commands.

Patch 3 adds a new --continue option to continue creating as many
namespaces as possible for the given filter spec.

Vishal Verma (3):
  Documentation: refactor 'bus options' into its own include
  Documentation: clarify bus/dimm/region filtering
  ndctl/namespace: add a --continue option to create namespaces greedily

 Documentation/ndctl/ndctl-check-namespace.txt |  4 +++
 Documentation/ndctl/ndctl-clear-errors.txt    |  4 +++
 .../ndctl/ndctl-create-namespace.txt          | 11 ++++++++
 Documentation/ndctl/ndctl-disable-dimm.txt    |  4 +++
 Documentation/ndctl/ndctl-disable-region.txt  |  4 +++
 Documentation/ndctl/ndctl-enable-dimm.txt     |  4 +++
 Documentation/ndctl/ndctl-enable-region.txt   |  4 +++
 Documentation/ndctl/ndctl-freeze-security.txt |  4 +++
 Documentation/ndctl/ndctl-inject-error.txt    |  4 +++
 Documentation/ndctl/ndctl-list.txt            |  4 +++
 .../ndctl/ndctl-remove-passphrase.txt         |  4 +++
 Documentation/ndctl/ndctl-sanitize-dimm.txt   |  4 +++
 .../ndctl/ndctl-setup-passphrase.txt          |  4 +++
 Documentation/ndctl/ndctl-update-firmware.txt |  4 +++
 .../ndctl/ndctl-update-passphrase.txt         |  4 +++
 Documentation/ndctl/ndctl-wait-overwrite.txt  |  4 +++
 Documentation/ndctl/xable-bus-options.txt     |  5 ++++
 Documentation/ndctl/xable-dimm-options.txt    | 14 +++--------
 .../ndctl/xable-namespace-options.txt         |  4 +++
 Documentation/ndctl/xable-region-options.txt  | 14 +++--------
 ndctl/namespace.c                             | 25 +++++++++++++++----
 21 files changed, 108 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/ndctl/xable-bus-options.txt

-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
