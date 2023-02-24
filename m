Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71117D8
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 05:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677217562; x=1708753562;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=MUvhPFbGDL7SH+wbQDaoTiqZSJ3jpVUHgEMwcEpg3QM=;
  b=difvC+8WhgMu+XdCHImW/kZ6MGB6eQ5G4/X5/sBqPZiuTD6cLS6Xv/aQ
   RQElK9o7gbkxy5hLTLWC55G4WMQQVgPiYVk8WSCxeWupD2/SlC85nJVW9
   PEK7tw7ZH05iao4kMm2gGSKFuDXsF4heIORyVx76bRlsD9EFgJit30bE+
   tBj0CKl2tX3XNF9nNmZFULjh2AUF9RPfN+F/M6+xBt/9+K0IiCG5tL4qT
   8CbK0/74IB6r2lzZ3i1XG9+I/VcVHTsKwtIWFXrAXia7at75jZ2CxZqh9
   9HZhCd9ZVHcDnlCtYPe/r/Iauiv9BzjxdSK9r3U7vN68sCyC6lv8AVPMu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="398137025"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="398137025"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:46:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="1001701702"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="1001701702"
Received: from kwameopo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.85.102])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:46:00 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 23 Feb 2023 22:45:39 -0700
Subject: [PATCH ndctl 2/2] cxl/event-trace: use the wrapped
 util_json_new_u64()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230223-meson-build-fixes-v1-2-5fae3b606395@intel.com>
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
In-Reply-To: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
To: linux-cxl@vger.kernel.org
Cc: =?utf-8?q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
 Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1530;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=MUvhPFbGDL7SH+wbQDaoTiqZSJ3jpVUHgEMwcEpg3QM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMk//MXnn1H5let/LfG9u9Gnxm28dZuLtDUeyuSsfn4lO
 aLBp5yjo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABM5WcDIsF3OtG/a2mxhL8n4
 4uPT7CseaDFNq/v3e+uc/ZkxKZ23rzEynEgzNd28O3k+S7x1XXKvMsM1E2Fn9Xee3LNeJfX8ZUp
 kBwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The json-c API json_object_new_uint64() is relatively new, and some distros
may not have it available. There is already a wrapped version in
util/json.h which falls back to the int64 API, based on meson's
determination of the availability of the uint64 version at compile time.
Replace the direct uint64 calls with this wrapped version.

Link: https://github.com/pmem/ndctl/issues/233
Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/event_trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 926f446..db8cc85 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -25,7 +25,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
 		if (sign)
 			return json_object_new_int64(*(int64_t *)num);
 		else
-			return json_object_new_uint64(*(uint64_t *)num);
+			return util_json_new_u64(*(uint64_t *)num);
 	}
 
 	/* All others fit in a signed 64 bit */
@@ -98,7 +98,7 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
 	}
 	json_object_object_add(jevent, "event", jobj);
 
-	jobj = json_object_new_uint64(record->ts);
+	jobj = util_json_new_u64(record->ts);
 	if (!jobj) {
 		rc = -ENOMEM;
 		goto err_jevent;

-- 
2.39.1

