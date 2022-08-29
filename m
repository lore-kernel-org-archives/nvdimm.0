Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217966104
	for <nvdimm@lists.linux.dev>; Mon, 29 Aug 2022 23:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661816523; x=1693352523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s9heJNo7hY6As6AqNo0+xd/BvLwH0HJGS32GiosR7m0=;
  b=CvehoWBpnDJ9F0Gw6Lq7E39XtV69IPwNFxua26UJWj8x+oFEYDhtWURd
   SNmcl6QxjKziqYcNqg3p8xbf5itfPLZe1jDOLyW0+xtyKUjUzdKfhXKPH
   BzOA6GbRWU54ziFsjmyqVFR6/4hyECOtdO6xea8G7JNm+HOYERPVtLukl
   7ud1hbwfeerEbGyXRbAaGzoYsxcB2Ji5uL14QJqlPxWHipsODurwtruck
   d6HsZ0sS83puDqzuxqGNTDjrWqGYF7bUXDDjSk6NdSHUUhp9IIo9pJFEO
   cOQPLM02vgLFox02NT8+KB63PcBgXEdPEDLxhLtjLCn0Qxb3PTANDKFxG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="358989947"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="358989947"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="588358109"
Received: from kmora1-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.213.169.48])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:00 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	corsepiu@fedoraproject.org,
	<linux-cxl@vger.kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl.spec.in: Address misc. packaging bugs (RHBZ#2100157)
Date: Mon, 29 Aug 2022 17:41:56 -0600
Message-Id: <20220829234157.101085-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829234157.101085-1-vishal.l.verma@intel.com>
References: <20220829234157.101085-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1538; h=from:subject; bh=s9heJNo7hY6As6AqNo0+xd/BvLwH0HJGS32GiosR7m0=; b=owGbwMvMwCXGf25diOft7jLG02pJDMm8fkc5Q2etOSv4pY+Du8H7nN6JqkR9G5m/kbyJvunfq9T8 JBd0lLIwiHExyIopsvzd85HxmNz2fJ7ABEeYOaxMIEMYuDgFYCJeAgz/o9LD29lnrf5zzlLcYNGB64 eVdJe+PbIu+tC3Z7eesHz9FMLwPy7lZGFQjPaXvws67qxzzDpSfyn3E/vttRrnHj5crXThEjsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Address some RPM packing bugs where the spec failed to claim parent
directories that it creates for config files.

Based on a patch by Ralf Corsépius <corsepiu@fedoraproject.org>

Link: https://src.fedoraproject.org/rpms/ndctl/c/401f506f1288384127e1ca20c64df64a9cd413f2?branch=rawhide
Cc: Ralf Corsépius <corsepiu@fedoraproject.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index cfcafa2..4788dab 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -171,9 +171,14 @@ fi
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/ndctl
 %{_unitdir}/ndctl-monitor.service
+
+%dir %{_sysconfdir}/ndctl
+%dir %{_sysconfdir}/ndctl/keys
 %{_sysconfdir}/ndctl/keys/keys.readme
+
 %{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
+%dir %{_sysconfdir}/ndctl.conf.d
 %config(noreplace) %{_sysconfdir}/ndctl.conf.d/monitor.conf
 %config(noreplace) %{_sysconfdir}/ndctl.conf.d/ndctl.conf
 
@@ -182,10 +187,11 @@ fi
 %license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT LICENSES/other/CC0-1.0
 %{_bindir}/daxctl
 %{_mandir}/man1/daxctl*
-%{_datadir}/daxctl/daxctl.conf
+%{_datadir}/daxctl
 %{bashcompdir}/daxctl
 %{_unitdir}/daxdev-reconfigure@.service
 %config %{_udevrulesdir}/90-daxctl-device.rules
+%dir %{_sysconfdir}/daxctl.conf.d/
 %config(noreplace) %{_sysconfdir}/daxctl.conf.d/daxctl.example.conf
 
 %files -n cxl-cli
-- 
2.37.2

