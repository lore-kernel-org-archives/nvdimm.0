Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EE43FDF
	for <nvdimm@lists.linux.dev>; Wed, 15 Jun 2022 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655333300; x=1686869300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+GoN0JKQwPR9kQh2/EvFvfDQG4fe645oBNCl7sLo6+o=;
  b=FHvH7kz/vSmfBx4jdl9KvY5aukrUTtrQZ019WsYkYBVCtt7S9Tm1puzh
   4hg4i1d/qXOfBERjtCD4j7ytpHSauzmt5OOV7ab9QNnDLvv6BLYb9Iu6O
   yaHFc34ULh+XJsyPz0W1f8kP9FisiDXgIcl7HWyWm2yeFXwn7Bvs2Jhdj
   hjQSy89cf7pefITk2qboK+E/2xRNYSwNXVO2EDcaW++u2WKBQkuoYEAxa
   SYhW4WdsxyrEhTaryYpV2HHpdr09nn71wEOtan7pZ7DKQ7LmVB+zWJDYj
   mavrj0YpFuU6WNRJz0hwP3ns5nHBszv/aPBvNJ65Do3JOLQFXoE+bpMhb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280150966"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280150966"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911896792"
Received: from rshirckx-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.81.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 4/5] scripts: fix contrib/do_abidiff for updated fedpkg
Date: Wed, 15 Jun 2022 16:48:12 -0600
Message-Id: <20220615224813.523053-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615224813.523053-1-vishal.l.verma@intel.com>
References: <20220615224813.523053-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=971; h=from:subject; bh=+GoN0JKQwPR9kQh2/EvFvfDQG4fe645oBNCl7sLo6+o=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrEtdEOMoXvrwoEnX4+cVzp1ObbXdvCD28IYQhxlCALdAm 6Rp3RykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACaiXczwT1PRp/RWg2bLAU1JlQ6h9x uOPhTnW5Crs0vnZHmwxgdjCUaGvyF1X9Ye3Jmt80yaWyHs/hLzKZ4Vq1jMf27wSDHJKTFlBAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A recent fedpkg update wants --name instead of --module-name.

Link: https://lore.kernel.org/r/20220106050940.743232-2-vishal.l.verma@intel.com
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 scripts/do_abidiff | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/do_abidiff b/scripts/do_abidiff
index 0bd7a16..e8c3a65 100755
--- a/scripts/do_abidiff
+++ b/scripts/do_abidiff
@@ -29,7 +29,7 @@ build_rpm()
 	version="$(./git-version)"
 	release="f$(basename $(readlink -f /etc/mock/default.cfg) | cut -d- -f2)"
 	git archive  --format=tar --prefix="ndctl-${version}/" HEAD | gzip > ndctl-${version}.tar.gz
-	fedpkg --release $release --module-name ndctl mockbuild
+	fedpkg --release $release --name=ndctl mockbuild
 	[ "$?" -eq 0 ] || err "error building $ref"
 	mkdir -p release/rel_${ref}/
 	cp results_ndctl/*/*/*.x86_64.rpm release/rel_${ref}/
-- 
2.36.1

