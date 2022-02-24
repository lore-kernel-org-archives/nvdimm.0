Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC4EC89
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 02:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645670508; x=1677206508;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x1Zf3E7qb/6C3DdDY2qCz7OEq48gX4VkHwan2faS2oo=;
  b=Exp3iLqJ449eUE/9Ech5Fuos9SCfVU2zFPvUlYUsUraitgx84g+IqVVg
   QvQQLKAVJF0OtcNz9F/OUNJ2kdTRMsw475zW6AsrDk9hi6b0jZxR5K2C4
   b6aDfn4o02UKyjnC702ygssfr+18F585Y/1LFZuERDQEwfV/kbVcr7Zu4
   6OXW+VANazDg5zbNIab3TMJeHI3yTHfeE1upiWM/xHzXMJuydzQ8SpplC
   2fGRsGphGoPOOhNVnhqcE/QWqYkuPsK0Ci9gVPaZTJYjJlBckor9sY5MB
   1zPyJIgUwNbz+1S8bp6HEkgUcRED7W8EEqfHGsvBv1yGtBWjrqvd8jR3w
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="251870012"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="251870012"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 18:41:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="548544548"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 18:41:45 -0800
Subject: [ndctl PATCH] build: Automate rpmbuild.sh
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Jane Chu <jane.chu@oracle.com>, nvdimm@lists.linux.dev
Date: Wed, 23 Feb 2022 18:41:45 -0800
Message-ID: <164567050589.2266739.68846452427328787.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Prior to the meson conversion rpmbuild.sh with no arguments would find a
pre-created ndctl.spec file relative to the script. Restore that
behavior by looking for the script in the build/ directory, and try to
create it if not there.

Yes, this fails if someone picks a directory other than build/ for the
output directory, but build/ is conventional.

Another regression from autotools is the loss of support for building
"dirty" rpms i.e. rpms from git source trees with uncommitted changes.
At least provide a coherent error message for that case.

Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 rpmbuild.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rpmbuild.sh b/rpmbuild.sh
index b1f4d9e5c0f3..d9823e5eda61 100755
--- a/rpmbuild.sh
+++ b/rpmbuild.sh
@@ -4,6 +4,15 @@ spec=${1:-$(dirname $0)/rhel/ndctl.spec)}
 
 pushd $(dirname $0) >/dev/null
 [ ! -d ~/rpmbuild/SOURCES ] && echo "rpmdev tree not found" && exit 1
+if ./git-version | grep -q dirty; then
+	echo "Uncommitted changes detected, commit or undo them to proceed"
+	git status -uno --short
+	exit 1
+fi
+if [ ! -f $spec ]; then
+	meson compile -C build rhel/ndctl.spec
+	spec=$(dirname $0)/build/rhel/ndctl.spec
+fi
 ./make-git-snapshot.sh
 popd > /dev/null
 rpmbuild --nocheck -ba $spec

