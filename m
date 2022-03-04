Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B67C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424409; x=1677960409;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2wFb4XORpN4X8F27ESFc+Wqe0C3768OwOF1qujeQbM8=;
  b=Ud08Nv3ja7MS8qYV180jx2bosM5katnN5Ubp/D3bNq32LLEe1q8Dbr70
   F5ZXzKhsH9nD4EzCXBZbRpXOTtfzKTNPXDrkT7pjpYNPX0vCvgSq+H4LQ
   RCMoGGSQywGmtFokM5lN2KDagziksQNQSw8iw/Ap+L3SBBdwKS7zgNtO1
   eMmROMjuq5zXtL8jDoN85p9IvvHYMb2Y6bVuJoAGJyUa+jr5S3ntn5ILO
   qvV4AXzY6QDXWTir6iCnMYUBN3x34mAZg2MmpMDj0o0+SuPXC5FTcNk5y
   O0puAxRE3/RXJ7WHNwJ2otUopO0C7UZaPXbI2kP9R5mSezLie227xvusC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251627921"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251627921"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:06:48 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="511968298"
Received: from rastinge-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.212.108.172])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:06:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] scripts/docsurgeon: Fix document header for section 1 man pages
Date: Fri,  4 Mar 2022 13:06:43 -0700
Message-Id: <20220304200643.1626110-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1233; h=from:subject; bh=2wFb4XORpN4X8F27ESFc+Wqe0C3768OwOF1qujeQbM8=; b=owGbwMvMwCXGf25diOft7jLG02pJDElKhS7Fpdq2ogl5liqchkVy5pXicnLz8/SCl8/SeJDfx9Kt 2NlRysIgxsUgK6bI8nfPR8ZjctvzeQITHGHmsDKBDGHg4hSAicjfYmTYcWZjxeXEV+VbTnC94DVWki 21yL06xeolb87EWHnLZLafDH+F7jplLwoMFOjNaXf+u1Nf6USKLMvZrffuZG423FXDO5cRAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Document header generation for section 1 man pages (cxl-foo commands) was
missing the section number in parenthesis, i.e. it would generate:

  cxl-foo
  =======

instead of:

  cxl-foo(1)
  ==========

resulting in asciidoc(tor) warnings.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 scripts/docsurgeon | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/docsurgeon b/scripts/docsurgeon
index ca0ad78..1421ef7 100755
--- a/scripts/docsurgeon
+++ b/scripts/docsurgeon
@@ -244,7 +244,7 @@ gen_cli()
 
 	# Start template generation
 	printf "%s\n" "$copyright_cli" > "$tmp"
-	gen_header "$name" >> "$tmp"
+	gen_header "$name($_arg_section)" >> "$tmp"
 	gen_section_name "$name" >> "$tmp"
 	gen_section_synopsis_1 "$name" >> "$tmp"
 	gen_section "DESCRIPTION" >> "$tmp"

base-commit: 55f36387ee8a88c489863103347ae275b1bc9191
prerequisite-patch-id: 24c7dc0c646c21238e4741a9432739788c908de7
prerequisite-patch-id: 2f5ab7c9c5b30aa585956e8a43dd2ec4d92d6afb
prerequisite-patch-id: 6ffa6ce0ea258fec17fa6066e4ee437ffd26307c
prerequisite-patch-id: 98f586353f89820d0b0e294c165dbbd7306cdd40
prerequisite-patch-id: 83f078f0afe936dc6f0e172f59da14412981a030
-- 
2.34.1

