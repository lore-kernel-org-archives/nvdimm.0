Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44622CA6
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641445817; x=1672981817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eE0j/Kjfk2j4VrokHn/u7alhQJpaYBabh8MEtcy+Trc=;
  b=JW6A3/RD01pEZIAJWywBeaGUdQTcGqRWhx/09BC8F3kx3eQyBmCXxMSl
   hpikG8S31tjF108tdLvbGanWt0u5UyCB7s/ZJRjO5dmTdYlAG1liiIgRL
   pKCQVQNcrO1McAUUahEA7mlU04vJ3tLStNHo3RrAP/+3bLAKkgSmVDetu
   e9KzbisOI183tfdO8Vqhypxxrlg1QLFlN3PrBrcHVSKjkTF0gFlj2hGVe
   KeBJOPn4T+h39iYhc3Bl4dCmUM2bH6/hKUGtnc7Pzurvh+3kCoPX0/c6c
   RbrAVpzBFXmVjWXVZOeZz5Ss0q1/6ma47p2yAHRlJ6ov4IiJsy4/Fb9dy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240138578"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="240138578"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="689272619"
Received: from asamymu-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.136.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:50 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] scripts: fix contrib/do_abidiff for updated fedpkg
Date: Wed,  5 Jan 2022 22:09:38 -0700
Message-Id: <20220106050940.743232-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106050940.743232-1-vishal.l.verma@intel.com>
References: <20220106050940.743232-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=835; h=from:subject; bh=eE0j/Kjfk2j4VrokHn/u7alhQJpaYBabh8MEtcy+Trc=; b=owGbwMvMwCXGf25diOft7jLG02pJDInXKqe8uL7o+o3mR+sYS2vSc9/Obf7Jezt5SvD+dQFfbz76 zfyGu6OUhUGMi0FWTJHl756PjMfktufzBCY4wsxhZQIZwsDFKQATec/D8Fde+puigoZxujFT1zZRUQ fVA3dqpA4c/v3W/H0Eu9nh/BhGhiWT/ER6XAqfyRbkxfOIKz3tloyY4btzW9Sm321Lly7V4QIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A recent fedpkg update wants --name instead of --module-name.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/do_abidiff | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/do_abidiff b/contrib/do_abidiff
index 0bd7a16..e8c3a65 100755
--- a/contrib/do_abidiff
+++ b/contrib/do_abidiff
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
2.33.1

