Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B002F22
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670366805; x=1701902805;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=a794AuGbH/PH6NpfV+HpFvRv1ixTVY/j1Ps0zvxgrqo=;
  b=OAXb6zLYcuNAo2g1QncKogg3KldBo2l9vcWe62uKXGEAzpnwuVoRMfO7
   dIaRZY+UyV775/XOQVDbhQ0zj6tgZlQ9oBAimg4ot48YUMsJI5eZiFOuj
   CmOCrYAKDdQ+3CN5ACzcT+E0AOsqj52v1bZ1hLKwHQfOE6WGH46iBYxTL
   RvjcU6Ed2CYrTk2kckKfVAarTJt3r6Qm3u4hPfbdzPgcl/DO7r/Ae6lV3
   SJ2qdv+dXLh8/X1nTyNAIpYMmK0AxmJg2cn4AfZjCovc5R+qN7yEVnqy5
   9AzscvKw3rRF9kycZhDY+/CSx7jKrGa45GTOz+V7XZqpmVhId9RL6pAUq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="315462746"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="315462746"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="714967834"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="714967834"
Received: from yguo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.82.140])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 06 Dec 2022 15:46:24 -0700
Subject: [PATCH ndctl 2/2] meson.build: add a check argument to run_command
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221206-vv-misc-v1-2-4c5bd58c90ca@intel.com>
References: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
In-Reply-To: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
To: nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
X-Mailer: b4 0.11.0-dev-b6525
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=a794AuGbH/PH6NpfV+HpFvRv1ixTVY/j1Ps0zvxgrqo=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMn9x5xkq+J/piUlTlSb1XguYuL65axXrpku2bEh32mK7N2r
 PG0eHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhInyXD/+ib+ix7N0fN4DYxM4wS3F
 BaqXer2NTjgvme/rwWycnSygz/g3OMHryesuNVVqnL3XDP1Sm/rPZ+XSQqGDVxk9HtOwGezAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Meson has started to warn about:

  WARNING: You should add the boolean check kwarg to the run_command call.
         It currently defaults to false,
         but it will default to true in future releases of meson.
         See also: https://github.com/mesonbuild/meson/issues/9300

There is one instance of run_command() in the top-level meson.build
which elides the explicit check argument. Since we don't care about the
result of clean_config.sh (if any config.h are found they will be
cleaned, and if none are found, we're fine), add a 'check: false'
argument to this and squelch the warning.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/meson.build b/meson.build
index 20a646d..33ed0ed 100644
--- a/meson.build
+++ b/meson.build
@@ -89,6 +89,7 @@ env = find_program('env')
 if git.found()
   run_command('clean_config.sh',
     env : 'GIT_DIR=@0@/.git'.format(project_source_root),
+    check : false,
   )
 endif
 

-- 
2.38.1
